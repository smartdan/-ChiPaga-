# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem 
  #include SslRequirement

  layout "guarantee"
  before_filter :login_required
  before_filter :is_maintenance, :except => 'service'
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private
  
  def is_administrator
    @user = current_user
     
    if self.authorized? 
     if @user.is_admin != 1
         flash[:notice] = 'Non sei amministratore'
         redirect_to home_path
     end
   else
      flash[:notice] = 'Non sei autorizzato'
      redirect_to home_path
    end
    
  end

  def admin?
    if self.logged_in?
     if current_user.is_admin == 1
       return true
     end
    end

    return false
  end

  
  def start
    if(admin?)
      man = Security.find_by_service('maintenance')
      man.value = 0
      man.save
      flash[:notice] = 'Applicazione avviata'
    else
      flash[:notice] = 'Non puoi effettuare questa operazione'
    end
  end
  
  def stop
    if(admin? )
      man = Security.find_by_service('maintenance')
      man.value = 1
      man.save
      flash[:notice] = 'Applicazione stoppata'
    else
        flash[:notice] = 'Non puoi effettuare questa operazione'
    end
  end
  
  def is_maintenance
     if @maintenance.nil? == false
        man = Security.find_by_service('maintenance')

        if(man.nil? == false)
           @maintenance = man.value
        else
           man = Security.new
           man.service = 'maintenance'
           man.value = 0
           man.save
           @maintenance = 0
        end
     end
     
     if admin? == false 
        if @maintenance == 1
           redirect_to :controller => 'home', :action => 'service'
        end
     end
    
  end
  
   
  
end
