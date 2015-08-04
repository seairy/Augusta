# -*- encoding : utf-8 -*-
class Caddie::VerificationCodesController < Caddie::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def sign_up
    begin
      raise InvalidPhone.new unless !!(params[:phone] =~ /^1\d{10}$/)
      VerificationCode.caddie_sign_up(caddie: @current_caddie, phone: params[:phone])
      render json: AjaxMessenger.new
    rescue InvalidPhone
      render json: AjaxMessenger.new('无效的手机号', false)
    rescue InvalidState
      render json: AjaxMessenger.new('无效的用户状态', false)
    rescue DuplicatedPhone
      render json: AjaxMessenger.new('手机号已被注册', false)
    rescue FrequentRequest
      render json: AjaxMessenger.new('请求验证码过于频繁', false)
    rescue TooManyRequest
      render json: AjaxMessenger.new('请求验证码次数过多，请联系客服', false)
    end
  end
end