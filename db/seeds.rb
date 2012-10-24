# USER_ROLE = { 
#   :admin => "Admin", #  add supplier 
#   :crew => "Crew",
#   :head_project_manager => "HeadProjectManager", # create projects, add client  , edit project membership
#   :project_manager => "ProjectManager",
#   :account_executive => "AccountExecutive" , 
#   # Back office roles .. there can be designer editor 
#   :production => "Production",
#   :post_production => "PostProduction"  
# }


manager_role = Role.create :name => USER_ROLE[:manager]
employee_role = Role.create :name => USER_ROLE[:employee] 
office = Office.create :name => "Ikkousa"
 
manager = User.create_user_with_role(   [manager_role, employee_role ], :name => "Head PM", 
                      :password => "willy1234", 
                      :password_confirmation => "willy1234", 
                      :email => "manager@gmail.com" )
manager.office_id = office.id
manager.save 
      
bar_seat_category = SeatCategory.create :name => "Bar", :office_id => office.id 
smoking_seat_category = SeatCategory.create :name => "Smoking Table", :office_id => office.id 
no_smoking_seat_category = SeatCategory.create :name => "No Smoking Table", :office_id => office.id 