class Role < ActiveRecord::Base
  attr_accessible :name
  has_many :users, :through => :assignments 
  has_many :assignments 
end
