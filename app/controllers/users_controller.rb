class UsersController < ApplicationController
 before_filter :is_administrator, :only =>['index','edit']
  
  # render new.rhtml
  def new
      @user = User.new
      @user.account = Account.new
      @user.account.money = 0
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user }
      end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    reset_session

    debugger
    @user = User.new
    @user.email = params[:user][:email]
    @user.login = params[:user][:login]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.is_admin = 0 #non amministratore

    @account = Account.new(params[:user][:account_attributes])
    @account.money = 0
    
    @user.register! if @user.valid?
    
    begin
      @user.save
      
      if @user.errors.empty?
          @account.user_id = @user.id
          @account.save
          flash[:notice] = "Grazie per la registrazione"
      else
          render :action => 'new'
      end
    rescue
      @user.destroy
      flash[:notice] = "Errori. Registrazione non avvenuta"
      render :action => 'new'
    end
  end

    def index
    #@users = User.paginate :per_page => 10, :page => params[:page]
   @users = User.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

    # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Utente aggiornato con successo'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
   @user = User.find(params[:id])
  end


   def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    #if logged_in? && !current_user.active?
    if !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup completo!"
      UserMailer.deliver_activation(current_user)
    else
       flash[:notice] = "Signup non completo!"
    end

    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.account.delete!
    @user.delete!

    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def change_password
     debugger
      return unless request.post?
      if User.authenticate(current_user.login, params[:old_password])
        if ((params[:password] == params[:password_confirmation]) &&
                              !params[:password_confirmation].blank?)
          current_user.password_confirmation = params[:password_confirmation]
          current_user.password = params[:password]

          if current_user.save
            flash[:notice] = "Password aggiornata con successo"
            UserMailer.deliver_reset_password(current_user)
            redirect_to profile_url(current_user.login)
          else
            flash[:alert] = "Password non cambiata"
          end

        else
          flash[:alert] = "La nuova password non coincide"
          @old_password = params[:old_password]
        end
      else
        flash[:alert] = "Vecchia password incorretta"
      end
    end

    #gain email address
    def forgot_password
      return unless request.post?
      if @user = User.find_by_email(params[:user][:email])
        @user.forgot_password
        @user.save
        redirect_back_or_default('/')
        UserMailer.deliver_forgot_password(@user)
        flash[:notice] = "Le istruzioni per il reset della password sono state inviate al tuo indirizzo di posta"
      else
        flash[:alert] = "Non esite un utente con questo indirizzo email"
      end
    end

    #reset password
    def reset_password
      debugger
      @user = User.find_by_password_reset_code(params[:id])
      return if @user unless params[:user]

      if ((params[:user][:password] && params[:user][:password_confirmation]) &&
                              !params[:user][:password_confirmation].blank?)
        self.current_user = @user #for the next two lines to work
        current_user.password_confirmation = params[:user][:password_confirmation]
        current_user.password = params[:user][:password]
        current_user.reset_password!
        flash[:notice] = current_user.save ? "Password resettata con successo" : "Password reset fallito"
        redirect_back_or_default('/')
      else
        flash[:alert] = "Le password non coincidono"
      end
    end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  private 
  
  def login_required
  end
  

end
