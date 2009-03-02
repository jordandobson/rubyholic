class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
#     @groups = Group.find( :all,
#                           :include => :locations,
#                           :order => @group_list,
#                           :limit => 10)

  def index
    get_sort_order
    @groups = Group.find  :all, 
                          :include => :location,
                          :select => 'id, name, description',
                          :order => @group_list

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid group #{params[:id]}")
      redirect_to_index('Invalid group')
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def show
    begin
      @group = Group.find(params[:id])
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @group }
      end
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

private

  def get_sort_order
    @sort_order = %w{ desc asc }.include?(params[:s]) ? params[:s].downcase : 'asc'
    @order_by   = 'groups'
    @group_list = "upper(name) #{@sort_order}"
  end

  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => :index
  end

end
