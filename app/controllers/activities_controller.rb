class ActivitiesController < ApplicationController
  # GET /activities
  # GET /activities.xml
  def index
    @page = 'activities'
    
    #@activities = Activity.paginate( :per_page => 10,
    #:page => params[:page],
    #:order => 'updated_at DESC',
    #:conditions => ["user_id == ?", current_user.id]
    #)
    @activities = Activity.find_all_by_user_id(current_user.id)
    
    if @activities.length == 0
     flash[:notice] = 'Non hai inserito attività'
     redirect_to current_user.account
    else
    
       respond_to do |format|
         format.html # index.html.erb
         format.xml  { render :xml => @activities }
      end
   end
  end

  # GET /activities/1
  # GET /activities/1.xml
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @activity = Activity.new
    @user = current_user
    @expiration =  Time.now
      
    @houses = @user.houses
    if @houses.length == 0
      redirect_to @user.account
    else 
       @selected_house = @houses[1]
     
       respond_to do |format|
         format.html # new.html.erb
         format.xml  { render :xml => @activity }
       end
    end
  end

  def new_for_user
    @activity = Activity.new
    @user = User.find(params[:user][:id])
    @house = House.find(params[:id])
    @expiration =  Time.now
    
    @house_id = @house.id
    @user_id = @user.id
    
    respond_to do |format|
       format.html # new_for_user.html.erb
       format.xml  { render :xml => @activity }
    end
  end
  
  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end


  def create_for_user
     debugger
     @activity = Activity.new
     @house = House.find(params[:house_id])
     @activity.name = params[:name]
     @activity.duration = params[:duration]
     @activity.house_id = @house.id
     @activity.cost = params[:cost]
     @activity.description = params[:description]
     @activity.expiration = Date.civil(params[:date_expiration][:"expiration(1i)"].to_i,params[:date_expiration][:"expiration(2i)"].to_i,params[:date_expiration][:"expiration(3i)"].to_i)
     @activity.user_id = params[:user_id]
     @activity.done = 0

    respond_to do |format|
      if @activity.save
        flash[:notice] = 'Attività creata correttamente'
        format.html { redirect_to(@activity) }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /activities
  # POST /activities.xml
  def create
    @activity = Activity.new

     @activity.name = params[:name]
     @activity.duration = params[:duration]
     @activity.house_id = params[:selected_house]
     @activity.cost = params[:cost]
     @activity.description = params[:description]
     @activity.expiration = Date.civil(params[:date_expiration][:"expiration(1i)"].to_i,params[:date_expiration][:"expiration(2i)"].to_i,params[:date_expiration][:"expiration(3i)"].to_i)

     @activity.user_id = current_user.id
     @activity.done = 0


    respond_to do |format|
      if @activity.save
        flash[:notice] = 'Attività creata correttamente'
        format.html { redirect_to(@activity) }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        flash[:notice] = 'Attività aggiornata correttamente'
        format.html { redirect_to(@activity) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end
end
