require 'httparty'
class Delivery < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :booking
  
  
  SENTLY_BASE_URL =  'https://sent.ly/command/sendsms?'
  
  def self.extract_authentication
    params = {}
    if Rails.env.production?
      params = YAML::load( File.open( Rails.root.to_s + "/config/sently.yml") )
    elsif Rails.env.development?
      params = YAML::load( File.open( Rails.root.to_s + "/config/sently_dev.yml") )
    end
    
    return params
  end
  
  def self.send_sms(employee, booking,  text, sms_delivery_case)
    params = self.extract_authentication 
    office = booking.office 
    #compose URL
    url = SENTLY_BASE_URL + 
          'username=' + params['auth']['username'] + '&'  + 
          'password=' + params['auth']['password'] + '&'  + 
          'to=' + CGI::escape( booking.phone_number) + '&' + 
          'text=' + CGI::escape(  text )
    # puts "The URL: #{url}\n"*10
    response = HTTParty.get( url )
     
    # successful : "Id:137967" 
    # error :
    success_regex = /^Id:(\d+)/
    fail_regex = /^Error:(\d+)/
    
    new_delivery = Delivery.new
    
    if fail_regex.match response.parsed_response
      error_code = $1.to_i 
      
      new_delivery.booking_id = booking.id 
      new_delivery.office_id  = booking.office_id 
      new_delivery.creator_id = employee.id 
      new_delivery.delivery_status  = SMS_DELIVERY_STATUS[:error] 
      new_delivery.is_error        = true 
      new_delivery.response_code      = error_code  
      
    elsif success_regex.match response.parsed_response 
      success_code = $1.to_i 
      
      new_delivery.booking_id = booking.id 
      new_delivery.office_id  = booking.office_id 
      new_delivery.creator_id = employee.id 
      new_delivery.delivery_status  = SMS_DELIVERY_STATUS[:sent_confirmed] 
      new_delivery.is_error        = false 
      new_delivery.response_code      = success_code 
    end
    
    new_delivery.delivery_case   = sms_delivery_case  
    
    new_delivery.save 
    
    
   
    
   
    
    return new_delivery  
  end
  
end
