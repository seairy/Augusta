# -*- encoding : utf-8 -*-
module V1
  module Users
    module Entities
      class SignUpSimple < Grape::Entity
        expose :uuid
        expose :type
        expose :nickname
        expose :token do |m, o|
          m.tokens.available.first.content
        end
      end
    end
  end
  
  class UsersAPI < Grape::API
    resources :users do
      desc '用户简单注册'
      post :sign_up_simple do
        user = User.sign_up_simple
        present user, with: Users::Entities::SignUpSimple
      end

      desc '用户注册'
      params do
        requires :phone, type: String, desc: '手机号码'
        requires :password, type: String, desc: '密码'
        requires :verification_code, type: String, desc: '验证码'
      end
      post :sign_up do
        User.sign_up
        present uuid: SecureRandom.uuid
      end
    end
  end
end
