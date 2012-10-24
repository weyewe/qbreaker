module ApplicationHelper
  ACTIVE = 'active'
  REVISION_SELECTED = "selected"
  NEXT_BUTTON_TEXT = "Next &rarr;"
  PREV_BUTTON_TEXT = " &larr; Prev "
  
  
=begin
  JOB REQUEST SPECIFIC
=end
  def get_job_request_color(job_request)
    job_request_source_symbol = JOB_REQUEST_SOURCE.invert[job_request.job_request_source]
    return PROJECT_ROLE_COLOR[JOB_REQUEST_ROLE[job_request_source_symbol]] 
  end
  
  def get_job_request_text(job_request)
    job_request_source_symbol = JOB_REQUEST_SOURCE.invert[job_request.job_request_source]
    return JOB_REQUEST_ROLE_TEXT[JOB_REQUEST_ROLE[job_request_source_symbol]] 
  end
  
   
  def get_finished_class(job_request)
    if job_request.is_finished == true 
      'strikethrough'
    else
      ''
    end
  end
  
  def get_job_request_message(job_request)
    case job_request.job_request_source
    when JOB_REQUEST_SOURCE[:assign_project_membership]
      return link_to "[#{job_request.project.title}] Project Membership Assignment Request", task_based_project_membership_assignment_url(job_request, job_request.project_id)
    when JOB_REQUEST_SOURCE[:concept_planning]
      return link_to "[#{job_request.project.title}] Concept Planning Request", concept_planning_fulfillment_url(job_request , job_request.project_id) 
    when JOB_REQUEST_SOURCE[:shoot]
      return link_to "[#{job_request.project.title}] Shoot Data", shoot_finalization_url(job_request, job_request.project_id )
    when JOB_REQUEST_SOURCE[:start_production]
      return link_to "[#{job_request.project.title}] Start Production by creating drafts for each deliverable component", task_based_deliverable_items_progress_url(job_request.project_id)
    when JOB_REQUEST_SOURCE[:production_scheduling]
      return link_to "[#{job_request.project.title}] Assign Production Team for "+ 
        "deliverable component: #{job_request.draft.deliverable_component_subcription.deliverable_component.name}, " + 
        "draft-#{job_request.draft.number}", task_based_production_team_assignment_url( job_request, job_request.project_id )
    when JOB_REQUEST_SOURCE[:production_execution]
      return link_to "[#{job_request.project.title}] Finish the draft-#{job_request.draft.number}", root_url
    when JOB_REQUEST_SOURCE[:qc_approval]
      return link_to "[#{job_request.project.title}] Draft approval for: draft-#{job_request.draft.number}", root_url
    when JOB_REQUEST_SOURCE[:client_start_draft_review]
      return link_to "[#{job_request.project.title}] Pass the draft to the client on " + 
                "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name} " + 
                "draft-#{job_request.draft.number}", root_url
    when JOB_REQUEST_SOURCE[:follow_up_client_draft_review]
      return link_to "[#{job_request.project.title}] Follow up with client to retrieve "+ 
            "the draft-#{job_request.draft.number}, from " + 
            "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name}", root_url
    when JOB_REQUEST_SOURCE[:component_post_production_scheduling]
      return link_to "[#{job_request.project.title}] Ask Post Production to  start working on "+  
            "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name}", root_url
    when JOB_REQUEST_SOURCE[:component_post_production_execution]
      return link_to "[#{job_request.project.title}] Start sourcing for supplier to produce "+  
            "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name}", root_url
    when JOB_REQUEST_SOURCE[:component_post_production_follow_up]
      return link_to "[#{job_request.project.title}] Do follow up to supplier to ensure timely delivery date for "+  
            "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name}", root_url
    when JOB_REQUEST_SOURCE[:post_production_delivery]
      return link_to "[#{job_request.project.title}] Post Production has retrieved "+  
            "deliverable component: #{job_request.deliverable_component_subcription.deliverable_component.name} " + 
            "from the supplier. Now, you can start planning the delivery to client", root_url
    else
      return link_to "Wrong MESSAGE", root_url 
    end 
  end
  
  def get_job_request_date(job_request)
    
  end
  

=begin
  Object List Display 
=end

  def show_table?( object_list )
    if object_list.length != 0 
      return ""
    end 
    return HIDE_TABLE 
  end



=begin
  For printing numbers (money)
=end

  def print_money(value)
    number_with_delimiter( value , :delimiter => ",")
  end
=begin
  Date helper
=end

  def format_date_from_datetime( datetime) 
    if datetime.nil? 
      return ""
    end
    "#{datetime.day}/#{datetime.month}/#{datetime.year}"
  end



  def select_hour_options
    array = ""
    (0..23).each do |x|
      array << "<option>#{x}</option>"
    end
    return array 
  end


=begin
  Utility methods
=end

  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
=begin
  BREADCRUMB
=end
  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
  def create_breadcrumb(breadcrumbs)
    
    if (  breadcrumbs.nil? ) || ( breadcrumbs.length ==  0) 
      # no breadcrumb. don't create 
    else
      breadcrumbs_result = ""
      breadcrumbs_result << "<ul class='breadcrumb'>"
      
      
      
      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 
      
      
      last_text = breadcrumbs.last.first
      last_path = breadcrumbs.last.last
      breadcrumbs_result << create_final_breadcrumb_element( link_to( last_text, last_path)  )
      breadcrumbs_result << "</ul>"
      return breadcrumbs_result
    end
    
    
  end
  
  def create_breadcrumb_element( link ) 
    element = ""
    element << "<li>"
    element << link
    element << "<span class='divider'>/</span>"
    element << "</li>"
    
    return element 
  end
  
  def create_final_breadcrumb_element( link )
    element = ""
    element << "<li class='active'>"
    element << link 
    element << "</li>"
    
    return element
  end
  
=begin
  SIDE PROCESS NAV
=end

  def get_process_nav( symbol, params ) 
    if symbol == :status
      return create_process_nav(STATUS_PROCESS_LIST, params )
    end
    
    if symbol == :master
      return create_process_nav(MASTER_PROCESS_LIST, params )
    end
    
    if symbol == :employee
      return create_process_nav(EMPLOYEE_PROCESS_LIST, params )
    end
  end
  
  def create_header_nav( process_list, params ) 
    result = ""
    result << "<div class='heading-bar'>"
    result << "<h5 class='pull-left'>"  + process_list[:header_title] + "</h5>"
    result << "</div>"
    return result
  end
  
  def create_process_nav( process_list, params )
    result = ""
    
    
    
    result << create_header_nav( process_list, params ) 
    result << "<ul class='aside-menu'>"
    
    
    process_list[:processes].each do |process|
      result << create_process_entry( process, params )
    end
    
    result << "</ul>" 
    return result
  end
   
  def create_process_entry( process, params )
    is_active = is_process_active?( process[:conditions], params) 
    process_entry = ""
    process_entry << "<li class='#{is_active}'>"
    process_entry << "<a href='#{extract_url( process[:destination_link] ) }'>"
    process_entry << "<i class='#{process[:icon_class]}'></i>"
    process_entry << process[:title] 
    process_entry << "</a>"
    process_entry << "</li>" 
                      
                      
    
    return process_entry
  end
  
  def is_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  STATUS_PROCESS_LIST = {
    :header_title => 'Status',
    :processes => [
      {
        :title => "Projects",
        :icon_class => 'icon-th-list',
        :destination_link => "projects_url",
        :conditions => [
          # project listing and project creation
          {
            :controller => "projects",
            :action => 'index'
          },
          {
            :controller => 'projects',
            :action => 'new'
          },
          {
            :controller => 'projects',
            :action => 'show'
          },
          # adding deliverable items 
          {
            :controller => 'deliverable_items',
            :action => "index"
          },
          {
            :controller => 'deliverable_items',
            :action => 'project_deliverable_items_production_overview'
          },
          # adding project member 
          {
            :controller => "project_memberships",
            :action => 'index'
          },
          # creating concept for the project 
          {
            :controller => "projects",
            :action => 'project_based_concept_planning_fulfillment'
          },
          {
            :controller => "projects",
            :action => 'project_based_shoot_finalization'
          },
          # creating draft : PRODUCTION 
          {
            :controller => 'drafts',
            :action => 'index'
          },
          # assigning production team
          {
            :controller => 'drafts',
            :action => 'production_team_assignment'
          },
          # assigning internal QC deadline 
          {
            :controller => 'drafts',
            :action => 'internal_qc_deadline_assignment'
          }
        ]
      },
      {
        :title => "Tasks",
        :icon_class => 'icon-tasks',
        :destination_link => "job_requests_url",
        :conditions => [
          {
            :controller => 'job_requests',
            :action => 'index'
          },
          {
            :controller => 'projects',
            :action => 'concept_planning_fulfillment'
          },
          {
            :controller => 'projects',
            :action => 'shoot_finalization'
          },
          {
            :controller => 'project_memberships',
            :action => "task_based_project_membership_assignment"
          },
          {
            :controller => 'deliverable_items',
            :action => 'task_based_deliverable_items_progress'
          },
          {
            :controller => 'drafts',
            :action => 'task_based_draft_creation_for_component'
          },
          {
            :controller => 'drafts',
            :action => 'task_based_production_team_assignment'
          }
        ]
      },
      {
        :title => 'Reminders',
        :icon_class => 'icon-envelope',
        :destination_link => "root_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
  MASTER_PROCESS_LIST = {
    :header_title => 'Master Data',
    :processes => [
      {
        :title => "Package",
        :icon_class => 'icon-briefcase',
        :destination_link => "packages_url",
        :conditions => [
          {
            :controller => 'packages',
            :action => 'index'
          },
          {
            :controller => 'deliverable_subcriptions',
            :action =>"index"
          }
        ]
      },
      {
        :title => "Deliverable + Component",
        :icon_class => 'icon-gift',
        :destination_link => "deliverables_url",
        :conditions => [
          {
            :controller => 'deliverables',
            :action => 'index'
          },
          {
            :controller => 'deliverable_components',
            :action => 'index'
          }
        ]
      }  
    ]
  }
  
  EMPLOYEE_PROCESS_LIST = {
    :header_title => 'Employee',
    :processes => [
      {
        :title => "Manpower Management",
        :icon_class => 'icon-user',
        :destination_link => "new_employee_creation_url",
        :conditions => [
          {
            :controller => 'offices',
            :action => 'new_employee_creation'
          }
        ]
      } 
    ]
  }
  
  def render_project_mini_app_nav( tab_array , params ) 
    result = ""
    active = ''
    result << "<ul class='nav nav-tabs header-tabs btn-block pull-right'>"
    tab_array.each do |tab_hash|
      active = "" 
      tab_hash[:conditions].each do |condition|
        if condition[:controller] == params[:controller] && 
            condition[:action] == params[:action]
          active = 'active'
          break 
        end
      end
      result << "<li class='#{active}'>"
        result << "<a href='#{tab_hash[:destination_url]}'>"
          if not tab_hash[:icon_class].nil? and not tab_hash[:icon_class].length == 0 
            result << "<i class='#{tab_hash[:icon_class]}'></i>" 
          end
          result << tab_hash[:tab_text]
        result << "</a>"
      result << "</li>"
    end
    
    result << "</ul>"
  end
   
  
  
  
  
  
  
  
=begin
  MAIN PROCESS NAVIGATION
=end
  def get_main_process_nav( symbol, params)

    if symbol == :project_management
      return create_main_process_nav(PROJECT_MANAGEMENT_PROCESS_LIST, params )
    end
    if symbol == :admin
      return create_main_process_nav(ADMIN_PROCESS_LIST, params )
    end
    if symbol == :head_project_manager
      return create_main_process_nav( HEAD_PROJECT_MANAGER_PROCESS_LIST, params )
    end 
  end
  
  PROJECT_MANAGEMENT_PROCESS_LIST = {
    :title => "Project Management",
    :destination_link => "projects_url",
    :conditions => [
      {
        :controller => 'projects',
        :action => 'index' 
      },
      {
        :controller => 'projects',
        :action => 'create'
      },
      {
        :controller => 'projects',
        :action => 'show'
      }
    ]
  }
  #######################################################
  #####
  #####     Start of the MAIN process navigation code 
  #####
  #######################################################
  def create_main_process_nav( process_list, params )
    result = ""
    is_active = is_main_process_active?( process_list[:conditions], params)
    result << "<li class='#{is_active}'>  "  +  
                  link_to( process_list[:title] , 
                    extract_url( process_list[:destination_link] )    ) + 
              "</li>"         
 
    return result
  end
    
  
  def is_main_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  def extract_url( some_url )
    if some_url == '#'
      return '#'
    end
    
    eval( some_url ) 
  end
  
end
