# -*- encoding : utf-8 -*-
class Cms::TeeBoxesController < Cms::BaseController
  
  def index
    @tee_boxes = TeeBox.page(params[:page])
  end
  
  def show
    @tee_box = TeeBox.find(params[:id])
  end
  
  def new
    @tee_box = TeeBox.new
  end
  
  def edit
    @tee_box = TeeBox.find(params[:id])
  end
  
  def create
    @tee_box = TeeBox.new(tee_box_params)
    if @tee_box.save
      redirect_to [:cms, @tee_box], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @tee_box = TeeBox.find(params[:id])
    if @tee_box.update_attributes(tee_box_params)
      redirect_to [:cms, @tee_box], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end

  def update_distance_from_hole
    tee_box = TeeBox.find(params[:id])
    if tee_box.update(distance_from_hole: params[:value])
      render json: { success: true, message: tee_box.distance_from_hole }
    else
      render json: { success: false, message: '格式不正确，请重新输入！' }
    end
  end
  
  def destroy
    @tee_box = TeeBox.find(params[:id])
    @tee_box.destroy
    redirect_to cms_tee_boxes_path, notice: '删除成功！'
  end

  protected
  def tee_box_params
    params.require(:tee_box).permit!
  end
end
