class GroupsController < ApplicationController

  def index
    get_sort_order
    @groups = Group.find  :all, 
                          :include => :locations,
                          :order => @group_list,
                          :conditions => @conditions,
                          :limit => 10

    respond_to do |format|
      format.html
    end
  end

private

  def get_sort_order
    @sort_order = %w{ desc asc }.include?(params[:s]) ? params[:s].downcase : 'asc'
    @order_by   = %w{ locations groups }.include?(params[:by]) ? params[:by].downcase : 'groups'
    @group_list = "upper(#{@order_by}.name) #{@sort_order}"
    @conditions = "#{@order_by}.name IS NOT NULL"
  end

  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => :index
  end

end