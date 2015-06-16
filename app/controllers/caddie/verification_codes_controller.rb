# -*- encoding : utf-8 -*-
class Caddie::VerificationCodesController < Caddie::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def sign_up
    begin
      VerificationCode.caddie_sign_up(phone: params[:phone])
      render json: { result: 'success', message: '验证码发送成功，请注意查收。' }
    rescue FrequentRequest
      render json: { result: 'success', message: '请求验证码过于频繁。' }
    rescue TooManyRequest
      render json: { result: 'success', message: '请求验证码次数过多。' }
    rescue DuplicatedPhone
      render json: { result: 'success', message: '您的手机号已经注册。' }
    end
  end
end
