# -*- encoding : utf-8 -*-
module V1
  class VerificationCodesAPI < Grape::API
    resources :verification_code do
      desc '发送验证码'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
        requires :type, type: String, values: VerificationCode.types.keys, desc: '类型'
      end
      get :send do
        begin
          VerificationCode.generate_and_send(phone: params[:phone], type: params[:type])
          present successful_json
        rescue FrequentRequest
          api_error!(20301)
        rescue DuplicatedPhone
          api_error!(20303)
        end
      end
    end
  end
end
