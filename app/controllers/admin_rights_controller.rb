class AdminRightsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    @rights = paginate3("Right", params[:page], hash, sort)
  end

  def new
    return redirect_to :action => "edit", :id => params[:id] if Right.find_by_id(params[:id])
  end

  def create
    right = Right.new(:data => [])
    right._id = params['id']
    par = params.select{|k,v| k.in?(admin_controller_names)}
    par.each do |k,v|
      case v
      when 'r'
        right.data << {'c' => k, "r" => true}
      when 'w'
        right.data << {'c' => k, "r" => false}
      end
    end
    right.save
    redirect_to :action => "show", :id => right.id
  end

  def show
    @right = Right.find(params[:id])
  end

  def edit
    @right = Right.find(params[:id])
  end

  def update
    @right = Right.find(params[:id])
    par = params.select{|k,v| k.in?(admin_controller_names)}
    par.each do |k,v|
      case v
      when 'none'
        @right.data.delete_if{|r| r['c'] == k }
      when 'r'
        next if @right.data.find{|d| d['c'] == k}
        @right.data << {'c' => k, "r" => true}
      when 'w'
        next if @right.data.find{|d| d['c'] == k}
        @right.data << {'c' => k, "r" => false}
      end
    end
    @right.save
    redirect_to :action => "show", :id => @right.id
  end


  def admin_controller_names
    data = ControllerName::Right
    names = []
    data.each_value{|e| names += e.keys}
    names
  end

end