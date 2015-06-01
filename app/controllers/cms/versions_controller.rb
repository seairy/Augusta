# -*- encoding : utf-8 -*-
class Cms::VersionsController < Cms::BaseController
  
  def index
    @versions = Version.page(params[:page])
  end
  
  def show
    @version = Version.find(params[:id])
  end
  
  def new
    @version = Version.new
  end
  
  def edit
    @version = Version.find(params[:id])
  end
  
  def create
    @version = Version.new(version_params)
    if @version.save
      redirect_to [:cms, @version], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @version = Version.find(params[:id])
    if @version.update_attributes(version_params)
      redirect_to [:cms, @version], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @version = Version.find(params[:id])
    @version.trash
    redirect_to cms_versions_path, notice: '删除成功！'
  end

  def publish
    @version = Version.find(params[:id])
    @version.publish!
    redirect_to [:cms, @version], notice: '发布成功！'
  end

  def cancel
    @version = Version.find(params[:id])
    @version.cancel!
    redirect_to [:cms, @version], notice: '取消发布成功！'
  end

  protected
  def version_params
    params.require(:version).permit!
  end
end
