class Booking < ActiveRecord::Base
  attr_accessible :name, :phone_number, :seat_category_id, :number_of_people
  belongs_to :seat_category
  belongs_to :office 
  has_many :deliveries 

  validates_presence_of :number_of_people, :seat_category_id, :name, :phone_number 
  validates_numericality_of :number_of_people 
  
=begin
  Object Creation
=end
  def self.create_object( employee, object_params ) 
    new_object = self.new object_params  
    new_object.creator_id = employee.id 
    new_object.office_id = employee.office_id

    # check that the phone number is the international format starts with +62
    if not new_object.is_international_format?( new_object.phone_number ) 
      new_object.errors.add(:phone_number , "Phone number has to be in international format: <b>+62</b> 821 255 73759." )  
      return new_object
    end
    
    if new_object.number_of_people.nil? or not new_object.number_of_people > 0 
      new_object.errors.add(:number_of_people , "Number of Guests has to be specified" )  
      return new_object
    end
 
    new_object.save 
    if new_object.persisted? 
      new_object.generate_yday
      new_object.generate_booking_code 
      
      new_object.delay.send_confirmation_sms(employee) 
      new_object.trigger_refresh_row
      # do the after_create activities 
      # send the sms confirmation 
    end

    return new_object
  end
  
  
  def self.active_bookings
    
    Booking.where{ booking_status.not_in [
        BOOKING_STATUS[:closed],
        BOOKING_STATUS[:canceled]
      ] }.order("created_at DESC")
  end
  
  
  def is_international_format?( phone_number ) 
    if phone_number.nil? or phone_number.length ==0  
      return false 
    end
      
    phone_number = phone_number.gsub(/\s+/, '')  
      
    regex = /^\+/
    
    if phone_number.match regex
      return true 
    else
      return false 
    end
  end
  
  def generate_yday 
    creation_date = self.created_at.to_date
    self.yday = creation_date.yday
    self.year = creation_date.year 
    self.save 
  end
  
  def generate_booking_code
    today_date = DateTime.now.to_date 
    total_booking_for_today = Booking.bookings_for_date( self.yday, self.year ).count 
    booking_code = ( (self.year%1000).to_s + self.yday.to_s + total_booking_for_today.to_s ).to_i.to_s(16)
    self.booking_code = booking_code
    self.save 
  end
  
  
  def Booking.bookings_for_date( yday, year )
    Booking.where(:yday => yday , :year => year ) 
  end
  
  # this method is always run in the backend
  # PUSHER: use the channel as the filter.. not the event 
  def send_confirmation_sms(employee)
    if ACTIVE_SMS_DELIVERY == true 
      delivery = Delivery.send_sms(employee , self,  self.office.confirmation_sms_text( self ), SMS_DELIVERY_CASE[:confirmation] )
      if delivery.is_error == true 
        self.booking_status = BOOKING_STATUS[:error_sending_confirmation]
      else
        self.booking_status = BOOKING_STATUS[:pending_seat]
      end
      
    else
      sleep(2);
      self.booking_status = BOOKING_STATUS[:pending_seat]
    end  
    self.save
    trigger_refresh_row
  end
   
  
  
  
  def send_seat_ready_notification(employee)
    if ACTIVE_SMS_DELIVERY == true 
      delivery = Delivery.send_sms(employee , self, self.office.seat_ready_sms_text( self ) , SMS_DELIVERY_CASE[:seat_ready] )  
    end
  end
  
  
  def trigger_refresh_row 
    pusher_message = {:object_id => self.id  }  
    Pusher["#{self.office.channel_code}"].trigger('refresh_row', 
            pusher_message)
  end
=begin
  FRONT GATE INTERACTION with the queue
=end

  def mark_as_ready(employee)
    self.booking_status = BOOKING_STATUS[:seat_ready]
    self.save
    trigger_refresh_row
  end
  
  
  def close_booking(employee)
    self.booking_status = BOOKING_STATUS[:closed]
    self.save
    trigger_refresh_row
  end
  
  def cancel_booking(employee) 
    self.booking_status = BOOKING_STATUS[:canceled]
    self.save 
    self.trigger_refresh_row
  end
  
  
  def last_delivery
    self.deliveries.order("created_at DESC").first 
  end
  
  def is_active?
    # not canceled or not not closed
    self.booking_status != BOOKING_STATUS[:closed] && 
      self.booking_status != BOOKING_STATUS[:canceled]
  end
  
  
  
  
   
end
