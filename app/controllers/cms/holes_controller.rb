# -*- encoding : utf-8 -*-
class Cms::HolesController < Cms::BaseController
  before_action :find_group, only: [:new, :create]
  
  def index
    @holes = Hole.page(params[:page])
  end
  
  def show
    @hole = Hole.find(params[:id])
  end
  
  def new
    @hole = Hole.new
  end
  
  def edit
    @hole = Hole.find(params[:id])
  end
  
  def create
    @hole = Hole.new(hole_params)
    if @hole.save
      redirect_to [:cms, @hole], notice: '球洞创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @hole = Hole.find(params[:id])
    if @hole.update_attributes(hole_params)
      redirect_to [:cms, @hole.course.venue], notice: '球洞更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @hole = Hole.find(params[:id])
    @hole.trash
    redirect_to cms_holes_path, notice: '删除成功！'
  end

  def update_par
    hole = Hole.find(params[:id])
    if hole.update(par: params[:value])
      render json: { success: true, message: hole.par }
    else
      render json: { success: false, message: '格式不正确，请重新输入！' }
    end
  end

  protected
  def find_group
    @group = Group.find(params[:group_id])
  end

  def hole_params
    params.require(:hole).permit!
  end
end
