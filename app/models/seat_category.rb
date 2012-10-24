class SeatCategory < ActiveRecord::Base
  attr_accessible :name , :office_id 
  belongs_to :office 
  has_many :bookings 
  
  
  def self.all_selectable_packages
    seat_categories  = SeatCategory.order("name ASC")
    result = []
    seat_categories.each do |seat_category| 
      result << [ "#{seat_category.name}" , 
                      seat_category.id ]  
    end
    return result
  end
end
