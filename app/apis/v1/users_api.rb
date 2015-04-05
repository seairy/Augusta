# -*- encoding : utf-8 -*-
module V1
  module Users
    module Entities
      class User < Grape::Entity
        expose :uuid
        expose :type
        expose :nickname
        expose :token do |m, o|
          m.available_token
        end
      end
    end
  end
  
  class UsersAPI < Grape::API
    resources :users do
      desc '用户简单注册'
      post :sign_up_simple do
        user = User.sign_up_simple
        present user, with: Users::Entities::User
      end

      desc '用户注册'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
        requires :password, type: String, desc: '密码'
        requires :verification_code, type: String, regexp: /^\d{4}$/, desc: '验证码'
      end
      post :sign_up do
        begin
          user = User.sign_up(phone: params[:phone], password: params[:password], verification_code: params[:verification_code])
          present user, with: Users::Entities::User
        rescue PhoneNotFound
          api_error!(20302)
        rescue DuplicatedPhone
          api_error!(20303)
        rescue InvalidVerificationCode
          api_error!(20304)
        end
      end

      desc '用户登录'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
        requires :password, type: String, desc: '密码'
      end
      post :sign_in do
        begin
          user = User.sign_in(phone: params[:phone], password: params[:password])
          present user, with: Users::Entities::User
        rescue PhoneNotFound
          api_error!(20302)
        rescue InvalidStatus
          api_error!(20305)
        rescue InvalidPassword
          api_error!(20306)
        end
      end

      desc '更新昵称'
      params do
        requires :nickname, type: String, desc: '昵称'
      end
      put :update_nickname do
        authenticate!
        if @current_user.update(nickname: params[:nickname])
          present successful_json
        else
          api_error!(20307)
        end
      end

      desc '更新性别'
      params do
        requires :gender, type: Integer, values: [1, 2], desc: '性别'
      end
      put :update_gender do
        authenticate!
        if @current_user.update(gender: params[:gender])
          present successful_json
        else
          api_error!(20308)
        end
      end

      desc '更新头像'
      params do
        requires :portrait, type: File, desc: '头像'
      end
      put :update_portrait do
        authenticate!
        if @current_user.update(portrait: params[:portrait])
          present successful_json
        else
          api_error!(20309)
        end
      end
    end
  end
end
