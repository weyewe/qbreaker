class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.integer :booking_id
      t.integer :office_id 
      t.integer :creator_id # the employee that triggers the delivery 
      
      t.integer :delivery_status , :default => SMS_DELIVERY_STATUS[:pending_trigger_send]
      
      t.boolean :is_error , :default => false 
      t.integer :response_code  
      
      t.integer :delivery_case , :default => SMS_DELIVERY_CASE[:confirmation]
      
      

      t.timestamps
    end
  end
end
