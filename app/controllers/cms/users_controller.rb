# -*- encoding : utf-8 -*-
class Cms::UsersController < Cms::BaseController
  
  def index
    @users = User.latest.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:cms, @user], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to [:cms, @user], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.trash
    redirect_to cms_users_path, notice: '删除成功！'
  end

  protected
  def user_params
    params.require(:user).permit!
  end
end
