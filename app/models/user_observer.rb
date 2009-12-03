class UserObserver < ActiveRecord::Observer

  def after_create(user)
    us = User.find(user.id)
    UserMailer.deliver_signup_notification(us)
  end

  #def after_save(user)
    #UserMailer.deliver_activation(user) if user.recently_activated?
    #UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
    #UserMailer.deliver_reset_password(user) if user.recently_reset_password?
  #end
end
