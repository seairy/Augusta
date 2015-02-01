# -*- encoding : utf-8 -*-
class Cms::SessionsController < Cms::BaseController
  skip_before_filter :authenticate, :find_notifications
  layout null: true

  def create
    administrator = Administrator.where(account: params[:account]).first.try(:authenticate, params[:password])
    unless administrator.blank?
      if administrator.available?
        administrator.update_attribute :last_signined_at, administrator.current_signined_at
        administrator.update_attribute :current_signined_at, Time.now
        session[:administrator] = { id: administrator.id, name: administrator.name, last_signined_at: administrator.last_signined_at }
        redirect_to cms_dashboard_path
      else
        redirect_to cms_signin_path, alert: '账号被禁用，无法登录'
      end
    else
      redirect_to cms_signin_path, alert: '账号或密码错误，请检查后重试'
    end
  end

  def destroy
    session[:administrator] = nil
    redirect_to cms_signin_path
  end
end
