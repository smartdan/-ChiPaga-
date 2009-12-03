class HousesController < ApplicationController
  # GET /houses
  # GET /houses.xml
  def index
    #@houses  = House.paginate( :per_page => 10,
    # :page => params[:page],
    # :order => 'updated_at DESC',
    # :conditions => ["creator_id == ?", current_user.id]
    # )
     
    @houses = current_user.houses

    if @houses.length == 0
        redirect_to current_user.account
    else
     
      respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @houses }
      end
    end
  end

  def partecipa
    debugger
    @house = House.find(params[:id])
    @share = HouseSharing.find_by_user_id(current_user.id, :conditions => ["house_id == ?", @house.id])
    
    if @share.nil?
       @hs = HouseSharing.new
       @hs.user_id = current_user.id
       @hs.house_id = @house.id
       @hs.active = 1
       @hs.save
       flash[:notice] = 'Inquilino aggiunto'
    else
       flash[:notice] = 'Sei già inquilino di questa casa'
    end
    redirect_to current_user.account
  end
  
  
  def esci_da_casa
      @house = House.find(params[:id])
      @share = HouseSharing.find_by_user_id(current_user.id, :conditions => ["house_id == ?", @house.id])

      if @share.nil? 
          flash[:notice] = 'Non sei inquilino di questa casa'
      else
         @share.destroy
         @share.save
         
         activities = Activity.find_all_by_user_id(current_user.id)
         activities.each do |act|
            if act.house_id == @house.id
               act.destroy
               act.save
            end
         end 
         
         flash[:notice] = 'Non sei più inquilino di questa casa'
      end
      redirect_to current_user.account
    end

  def cerca_casa
   @house = House.find_by_name(params[:nome_casa])
   
   if @house == nil
      flash[:notice] = 'Casa non trovata'
      redirect_to current_user.account
   else
      redirect_to @house
   end
      
  end

  def notifica_chiusura
     @house = House.find(params[:id])
     variabili_spesa(@house)
  end
  
  def variabili_spesa(house)
    @inquilini = house.users
    @creator = User.find(house.creator_id)
    @inizio_mese = 1.month.ago
    @spesa_tot = Activity.sum :cost,  :conditions => ["house_id =" + house.id.to_s + " and done = 0 and created_at > ?", @inizio_mese]
    @inquilini_spesa = Hash.new
    @inquilini_dare_avere = Array.new
	
    @inquilini.each do |inq|
      @inquilini_spesa[inq] = Activity.sum :cost,  :conditions => ["user_id = " + inq.id.to_s + " and house_id=" + house.id.to_s + " and created_at > ?", @inizio_mese]
      @inquilini_dare_avere << (@inquilini_spesa[inq] - (@spesa_tot / @inquilini.length))
    end
  end
  
  
  def invia_notifica
     debugger
      body = params[:body]
      from = current_user.login
  	   
  	  @house = House.find(params[:id])
      variabili_spesa(@house)
      
      begin
         @house.users.each do |us|
            @destination = us
            
  	        email_params = Hash.new
            email_params["from"] = from
            email_params["user"] = @destination
            email_params["text"] = body.to_s
            email_params["house"] = @house 
            email_params["spesa_tot"] = @spesa_tot
            email_params["inquilini_spesa"] = @inquilini_spesa
            
            Notifier.deliver_pagamenti_email(email_params)
			flash[:notice] = 'Comunicazione inviata a ' + @destination.login
         end
      rescue
         flash[:notice] = 'Comunicazione non inviata'
      end
	  redirect_to current_user.account
   end
    
  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])
    variabili_spesa(@house)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @house }
    end
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    @house = House.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @house }
    end
  end

  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.xml
  def create
    @house = House.new(params[:house])

    @house.creator_id = current_user.id

    respond_to do |format|
      if @house.save

        @house_sharing = HouseSharing.new
        @house_sharing.house_id = @house.id
        @house_sharing.user_id = current_user.id
        @house_sharing.active = 1
        @house_sharing.save

        flash[:notice] = 'Casa creata correttamente'
        format.html { redirect_to(@house) }
        format.xml  { render :xml => @house, :status => :created, :location => @house }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    @house = House.find(params[:id])

    respond_to do |format|
      if @house.update_attributes(params[:house])
        flash[:notice] = 'Casa aggiornata correttamente.'
        format.html { redirect_to(@house) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    @house = House.find(params[:id])
    if @house.users.length == 0
       @house.destroy
        
    respond_to do |format|
      flash[:notice] = 'Casa eliminata'
      format.html { redirect_to(current_user.account) }
      format.xml  { head :ok }
    end
   else
      flash[:notice] = 'Non puoi eliminare questa casa. Esistono ancora coinquilini'
      redirect_to @house
   end
  end
end
