class BookingsController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:public_index, :refresh_public_booking_queue_row]
  def index
    @objects = Booking.active_bookings
    @new_object = Booking.new 
    
    
    add_breadcrumb "Queue Management", 'bookings_url'
  end
  
  def public_index
    @objects = Booking.active_bookings
    @new_object = Booking.new
    
    add_breadcrumb "Queue Management", 'root_url'
  end
  
  
  def create 
    @new_object =  Booking.create_object( current_user, params[:booking])  
  end
  
  def send_booking_ready_notification
    
    @booking = Booking.find_by_id params[:entity_id]
    @booking.mark_as_ready(current_user ) 
    @booking.delay.send_seat_ready_notification(current_user)
    @object = @booking
  end
  
  def close_booking
    @booking = Booking.find_by_id params[:entity_id]
    @booking.close_booking(current_user)
  end
  
  def cancel_booking
    @booking = Booking.find_by_id params[:entity_id]
    @booking.cancel_booking(current_user)
  end
  
  def refresh_booking_queue_row
    @object = Booking.find_by_id params[:object_id]
  end
  
  def refresh_public_booking_queue_row
    @object = Booking.find_by_id params[:object_id]
  end
  
  
end
