class GroupsController < ApplicationController

  def index
    get_sort_order

    @groups = Group.find  :all, 
                          :include => :locations,
                          :order => @group_list,
                          :conditions => @conditions,
                          :limit => 10

#     @groups = params[:q] ? Group.serach(params[:q]) : Group.find  :all, 
#                           :include => :locations,
#                           :order => @group_list,
#                           :conditions => @conditions,
#                           :limit => 10

    respond_to do |format|
      format.html
    end
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @group = Group.new(params[:group])
    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @group = Group.find   params[:id],
                          :include => [:events, :locations],
                          :order => "events.start_date ASC"
    respond_to do |format|
      format.html
    end
  end

  def edit
    @group = Group.find(params[:id])  
  end

  def update
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update_attributes(params[:group])
        #flash[:notice] = 'Group updated.'
        format.html { redirect_to(@group) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

private

  def get_sort_order
    @sort_order = %w{ desc asc }.include?(params[:s])           ? params[:s].downcase   : 'asc'
    @order_by   = %w{ locations groups }.include?(params[:by])  ? params[:by].downcase  : 'groups'
    @group_list = "upper(#{@order_by}.name) #{@sort_order}"
    @conditions = "#{@order_by}.name IS NOT NULL"
  end

  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => :index
  end

end
