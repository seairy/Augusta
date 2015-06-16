# -*- encoding : utf-8 -*-
class Caddie::SessionsController < Caddie::BaseController
  skip_before_filter :authenticate

  def create
    begin
      caddie = Caddie.sign_in(phone: params[:phone], password: params[:password])
      session[:caddie] = { id: caddie.id, name: caddie.name, last_signined_at: caddie.last_signined_at }
      redirect_to caddie_dashboard_path
    rescue PhoneNotFound
      redirect_to caddie_signin_path, alert: '账号不存在，请检查后重试'
    rescue InvalidStatus
      redirect_to caddie_signin_path, alert: '账号被禁用，无法登录'
    rescue InvalidPassword
      redirect_to cms_signin_path, alert: '密码错误，请检查后重试'
    end
  end

  def destroy
    session[:caddie] = nil
    redirect_to caddie_signin_path
  end
end
