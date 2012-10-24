class OfficesController < ApplicationController
  def new_employee_creation
    @new_employee = User.new 
    @employees = User.order("created_at DESC")
    
    add_breadcrumb "Manpower Management", 'new_employee_creation_url'
  end
  
  def create_employee
    @new_object = User.create_basic_user(current_user,  params[:user] )   
    
    
    # what's gonna happen if it is jquery AJAX ? 
    
    # if not @new_employee.nil? and @new_employee.valid?
    #   flash[:notice] = "The employee '#{@new_employee.email}' has been created." 
    #   redirect_to new_employee_creation_url
    #   return 
    # else
    #   @employees = current_office.users
    #   @new_employee = User.new 
    #   flash[:error] = []
    #   if params[:user][:email].nil? or params[:user][:email].length == 0 
    #     flash[:error] << "Email has to be present"
    #   end
    #   
    #   if User.find_by_email(params[:user][:email]).nil?
    #     flash[:error] << "There is duplicate email"
    #   end
    #     
    #   render :file => "offices/new_employee_creation"
    # end
  end
  
  def show_role_for_employee
    @employee = User.find_by_id params[:employee_id]
    @roles = Role.find(:all, :order => "created_at ASC")
    
    add_breadcrumb "Manpower Management", 'new_employee_creation_url'
    set_breadcrumb_for @employee, 'show_role_for_employee_url' + "(#{@employee.id})", 
                " Role Assignment for #{@employee.name} "
                
                
  end
  
  def assign_role_for_employee
    @decision = params[:membership_decision].to_i
    @role = Role.find_by_id params[:membership_provider]
    @employee = User.find_by_id params[:membership_consumer] 
  
    if @decision == TRUE_CHECK
      puts "**** WE are calling add role "
      # @employee.add_role(@role, @office, current_user)
      @employee.add_role( @role,  current_user)
    elsif @decision == FALSE_CHECK
      puts "((((( We are calling remove role)))))"
      @employee.remove_role(@role,  current_user)
    end
    @employee.reload 
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
end
