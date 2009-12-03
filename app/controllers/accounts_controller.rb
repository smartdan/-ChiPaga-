class AccountsController < ApplicationController
  before_filter :is_administrator, :only => [:index, :destroy, :start_app, :stop_app]
  
  #before_filter :login_required, :only => [:show, :edit, :update, :index]
  
  # GET /accounts
  # GET /accounts.xml
  def index
    #@accounts = Account.paginate :per_page => 10, :page => params[:page], :order => 'updated_at DESC'
    @accounts = Account.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    if @account != nil
      if current_user.account.id != @account.id
       flash[:notice] = 'Non è il tuo account'
       redirect_to home_path
      else
        @inizio_mese = 1.month.ago 
        @houses = @account.user.houses

        @spesa_personale = Activity.sum :cost,  :conditions => ["user_id = " + current_user.id.to_s + " and created_at > ?", @inizio_mese]
        @spesa_case = 0.0
       
        @houses.each do |hhh|
          @spesa_case += ((Activity.sum :cost,  :conditions => ["house_id = " + hhh.id.to_s + " and created_at > ?", @inizio_mese]) / hhh.users.length)
        end

        respond_to do |format|
         format.html # show.html.erb
         format.xml  { render :xml => @account }
        end
      end
    else
       flash[:notice] = 'Non è il tuo account'
       redirect_to home_path
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end


  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account aggiornato'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def start_app
     @account = Account.find(params[:id])
     start
     redirect_to @account
   end

   def stop_app
     @account = Account.find(params[:id])
     stop
     redirect_to @account
   end
   
  private 
  
  
end
