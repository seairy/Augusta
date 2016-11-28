# -*- encoding : utf-8 -*-
class Caddie::CaddiesController < Caddie::BaseController
  skip_before_action :sign_up

  def sign_up_form
  end

  def sign_up
    begin
      raise InvalidPhone.new unless !!(caddie_params[:phone] =~ /^1\d{10}$/)
      raise InvalidVerificationCode.new unless !!(params[:verification_code] =~ /^\d{4}$/)
      raise Invalidname.new unless !!(caddie_params[:name] =~ /^[0-9A-Za-z_\u4e00-\u9fa5]{4,16}$/)
      @current_caddie.sign_up(phone: caddie_params[:phone], verification_code: params[:verification_code], name: caddie_params[:name])
      render json: AjaxMessenger.new
    rescue InvalidPhone
      render json: AjaxMessenger.new('无效的手机号', false)
    rescue InvalidVerificationCode
      render json: AjaxMessenger.new('无效的验证码', false)
    rescue InvalidName
      render json: AjaxMessenger.new('无效的姓名', false)
    rescue InvalidState
      render json: AjaxMessenger.new('无效的用户状态', false)
    rescue DuplicatedPhone
      render json: AjaxMessenger.new('手机号已被注册', false)
    rescue IncorrectVerificationCode
      render json: AjaxMessenger.new('错误的验证码', false)
    end
  end

  protected
    def caddie_params
      params.require(:caddie).permit!
    end
end
