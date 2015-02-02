# -*- encoding : utf-8 -*-
module Resources
  class User < Grape::API
    resources :users do
      desc '用户简单注册'
      post :sign_up_simple do
        User.sign_up_simple
        present uuid: SecureRandom.uuid
      end

      desc '用户注册'
      params do
        requires :phone, type: String, desc: '手机号码'
        requires :verification_code, type: String, desc: '验证码'
      end
      post :sign_up do
        User.sign_up
        present uuid: SecureRandom.uuid
      end
    end

    resources :verification_codes do
      desc '获取验证码'
      params do
        requires :phone, type: String, desc: '手机号码'
      end
      post '/' do
        present verification_code: rand(123456..987654)
      end
    end
  end
end
