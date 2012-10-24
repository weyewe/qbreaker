class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :users 
  has_many :bookings 
  has_many :deliveries 
  has_many :seat_categories 
  
  after_create :create_channel_code
  
  
  
  def create_channel_code
    creation_time = self.created_at
    channel_code = ""
    channel_code << creation_time.year.to_s + creation_time.month.to_s + creation_time.day.to_s 
    channel_code << self.id.to_s
    self.channel_code = channel_code.to_i.to_s(16)
    self.save 
  end
  
  def confirmation_sms_text( booking )
    sms_string = ""
    sms_string << "[#{self.name}]-Confirmation\n"  
    sms_string << "#{booking.name}\n" 
    sms_string << "Code: #{booking.booking_code}\n" 
    sms_string << "#{booking.seat_category.name}\n" 
    people_enumerator = ''
    if booking.number_of_people > 1 
      people_enumerator = 'people'
    else
      people_enumerator = 'person'
    end
    
    sms_string << "#{booking.number_of_people} #{people_enumerator}" 
  end
  
  def seat_ready_sms_text(booking)
    sms_string = ""
    sms_string << "[#{self.name}]-Ready\n"  
    sms_string << "#{booking.name}\n" 
    sms_string << "Code: #{booking.booking_code}\n" 
    sms_string << "#{booking.seat_category.name}\n" 
    people_enumerator = ''
    if booking.number_of_people > 1 
      people_enumerator = 'people'
    else
      people_enumerator = 'person'
    end
    
    sms_string << "#{booking.number_of_people} #{people_enumerator}"
  end
end
