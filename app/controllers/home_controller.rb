class HomeController < ApplicationController
   #caches_action :index, :layout => false #:unless => Proc.new { |controller| controller.logged_in? }
   #caches_action :contacts, :layout => false #:unless => Proc.new { |controller| controller.logged_in? }
   #caches_action :invia_comunicazione, :layout => false
   #caches_action :service, :layout => false
   #caches_action :about, :layout => false
   
  def index
     @page = 'index'
  end

  def about
     @page = 'about'
  end

  def contacts
     @page = 'contacts'
  end

  def service
    if @maintenance == 0
       
      redirect_to :controller =>'home', :action => 'index'
      flash[:notice] = 'Non in manutenzione'
    end 
  end
  
  def invia_comunicazione
    body = params[:body]

   if logged_in?
     from = current_user.login
	 else
		 from = 'unknown'
    end

    @destination = User.find_by_login('Admin')

    begin
	    email_params = Hash.new
       email_params["from"] = from
       email_params["user"] = @destination
       email_params["text"] = body.to_s
       Notifier.deliver_comment_email(email_params)
	    flash[:notice] = 'Comunicazione inviata'
	    redirect_to home_path
	 rescue
        flash[:notice] = 'Comunicazione non inviata'
	 	  redirect_to home_path
    end
  end

  private 
  
  def login_required
  end
  
end
