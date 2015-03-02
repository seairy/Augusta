# -*- encoding : utf-8 -*-
module V1
  class VerificationCodesAPI < Grape::API
    resources :verification_code do
      desc '发送验证码'
      params do
        requires :phone, type: String, desc: '手机号码'
      end
      get :send do
        VerificationCode.generate_and_send(phone: params[:phone])
        present nil
      end
    end
  end
end
