# -*- encoding : utf-8 -*-
module V1
  module Entities
    class SignUpSimple < Grape::Entity
      expose :uuid
      expose :nickname
      expose :token do |m, o|
        m.tokens.available.first.content
      end
    end
  end
  
  class UsersAPI < Grape::API
    resources :users do
      desc '用户简单注册'
      post :sign_up_simple do
        user = User.sign_up_simple
        present user, with: Entities::SignUpSimple
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
