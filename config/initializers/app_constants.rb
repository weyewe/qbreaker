COMPANY_NAME = "qBreaker"
COMPANY_TITLE = "qBreaker"
=begin
  MODEL CONSTANT
=end
JAKARTA_HOUR_OFFSET = 7 
# in the whole application 
USER_ROLE = { 
  :manager => "Manager", 
  :employee => "Employee" 
}
 

 

DEFAULT_TIMEZONE = "Jakarta"
DEFAULT_TIME_OFFSET = 7 

MIN_YDAY = 1
MAX_YDAY = 366



 
=begin
  CONSTANT for AJAX
=end
TRUE_CHECK = 1
FALSE_CHECK = 0

PROPOSER_ROLE = 0 
APPROVER_ROLE = 1



 
=begin
  DISPLAY RELATED
=end
INDEPENDENT_ARTICLE_VALUE = 0 
ARTICLE_FROM_PROJECT_VALUE =  1 

FRONT_PAGE_WIDTH = 325
ARTICLE_WIDTH = 800
 


SHOWLOADING_LOADER_URL = "http://s3.amazonaws.com/circle-static-assets/loading.gif"

# APP HELPER
HIDE_TABLE = "object_list_hidden"

=begin
JOB REQUEST SPECIFIC
=end
NUMBER_OF_DAYS_TO_START_PRODUCTION = 7
NUMBER_OF_DAYS_TO_START_PRODUCTION_SCHEDULING = 4

SHOW_NOTE = true 


BOOKING_STATUS = {
  :error_sending_confirmation => -2,  
  :pending_confirmation_sms => -1,  
  :pending_seat => 0, 
  :error_sending_seat_ready_notification => 1, 
  :seat_ready => 2 , 
  :closed => 3, 
  :canceled => 4 
}

SMS_DELIVERY_STATUS=  {
  :pending_trigger_send => 0 ,
  :sent_not_confirmed => 1, 
  :sent_confirmed => 2,
  :error => 3  
}

SMS_DELIVERY_CASE = {
  :confirmation => 0, 
  :seat_ready => 1 
}

# 
ACTIVE_SMS_DELIVERY = true  
