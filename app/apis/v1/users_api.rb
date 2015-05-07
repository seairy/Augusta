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

      class Portrait < Grape::Entity
        expose :user do
          expose :portrait do |m, o|
            oss_image(m, :portrait, :w300_h300_fl_q50)
          end
        end
      end

      class Details < Grape::Entity
        expose :gender
        with_options(format_with: :timestamp){expose :birthday}
        expose :description
        expose :handicap
        with_options(format_with: :timestamp){expose :signed_up_at}
        with_options(format_with: :timestamp){expose :last_signed_in_at}
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
        requires :password_confirmation, type: String, desc: '确认密码'
        requires :verification_code, type: String, regexp: /^\d{4}$/, desc: '验证码'
      end
      post :sign_up do
        begin
          raise InvalidPasswordConfirmation.new unless params[:password] == params[:password_confirmation]
          user = User.sign_up(phone: params[:phone], password: params[:password], verification_code: params[:verification_code])
          present user, with: Users::Entities::User
        rescue InvalidPasswordConfirmation
          api_error!(20309)
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

      desc '用户注销'
      delete :sign_out do
        authenticate!
        @current_user.sign_out
        present successful_json
      end

      desc '用户头像'
      get :portrait do
        authenticate!
        present @current_user, with: Users::Entities::Portrait
      end

      desc '用户详细资料'
      get :details do
        authenticate!
        present @current_user, with: Users::Entities::Details
      end

      desc '更新密码'
      params do
        requires :original_password, type: String, desc: '原密码'
        requires :password, type: String, desc: '新密码'
        requires :password_confirmation, type: String, desc: '确认密码'
      end
      put :update_password do
        authenticate!
        begin
          raise InvalidPasswordConfirmation.new unless params[:password] == params[:password_confirmation]
          if @current_user.update_password(original_password: params[:original_password], password: params[:password])
            present successful_json
          else
            api_error!(20306)
          end
        rescue InvalidPasswordConfirmation
          api_error!(20309)
        rescue InvalidOriginalPassword
          api_error!(20310)
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
        requires :portrait, desc: '头像'
      end
      put :update_portrait do
        authenticate!
        begin
          if @current_user.update(portrait: params[:portrait])
            present @current_user, with: Users::Entities::Portrait
          else
            api_error!(20311)
          end
        rescue RestClient::RequestTimeout
          api_error!(10005)
        end
      end

      desc '更新签名'
      params do
        requires :description, type: String, desc: '签名'
      end
      put :update_description do
        authenticate!
        if @current_user.update(description: params[:description])
          present successful_json
        else
          api_error!(20312)
        end
      end

      desc '更新出生日期'
      params do
        requires :birthday, desc: '出生日期'
      end
      put :update_birthday do
        authenticate!
        if @current_user.update_birthday(params[:birthday].to_i)
          present successful_json
        else
          api_error!(20313)
        end
      end

      desc '更新头像、昵称及性别'
      params do
        requires :portrait, desc: '头像'
        requires :nickname, type: String, desc: '昵称'
        requires :gender, type: Integer, values: [1, 2], desc: '性别'
      end
      put :update_portrait_and_nickname_and_gender do
        authenticate!
        if @current_user.update(declared(params))
          present successful_json
        else
          api_error!(20314)
        end
      end
    end
  end
end
