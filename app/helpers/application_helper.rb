# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 def user_logged_in?
      session[:user_id]
 end

def admin?

  if user_logged_in?
    @user = current_user

  	 if @user.is_admin == 1
         return true

    else
     		return false
    end
 end
end

end
