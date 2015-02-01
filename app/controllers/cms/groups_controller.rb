# -*- encoding : utf-8 -*-
class Cms::GroupsController < Cms::BaseController
  before_action :find_course, only: [:new, :create]
  
  def index
    @groups = Group.page(params[:page])
  end
  
  def show
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to [:cms, @group], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to [:cms, @group], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.trash
    redirect_to cms_groups_path, notice: '删除成功！'
  end

  protected
  def find_course
    @course = Course.find(params[:course_id])
  end

  def group_params
    params.require(:group).permit!
  end
end
