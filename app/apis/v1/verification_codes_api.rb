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
          VerificationCode.sign_up(phone: params[:phone], type: params[:type])
          present successful_json
        rescue FrequentRequest
          api_error!(20301)
        rescue DuplicatedPhone
          api_error!(20303)
        end
      end

      desc '获取用户注册验证码'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
      end
      get :sign_up do
        begin
          VerificationCode.sign_up(phone: params[:phone])
          present successful_json
        rescue FrequentRequest
          api_error!(20301)
        rescue TooManyRequest
          api_error!(20315)
        rescue DuplicatedPhone
          api_error!(20303)
        end
      end

      desc '获取用户简单登录验证码'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
      end
      get :sign_in_simple do
        begin
          VerificationCode.sign_in_simple(phone: params[:phone])
          present successful_json
        rescue FrequentRequest
          api_error!(20301)
        rescue TooManyRequest
          api_error!(20315)
        rescue PhoneNotFound
          api_error!(20302)
        rescue InvalidUserType
          api_error!(20316)
        end
      end

      desc '获取用户升级验证码'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
      end
      get :upgrade do
        authenticate!
        begin
          VerificationCode.upgrade(user: @current_user, phone: params[:phone])
          present successful_json
        rescue FrequentRequest
          api_error!(20301)
        rescue TooManyRequest
          api_error!(20315)
        rescue DuplicatedPhone
          api_error!(20303)
        rescue InvalidUserType
          api_error!(20316)
        end
      end

      desc '获取重置密码验证码'
      params do
        requires :phone, type: String, regexp: /^1\d{10}$/, desc: '手机号码'
      end
      get :reset_password do
        begin
          VerificationCode.reset_password(phone: params[:phone])
          present successful_json
        rescue PhoneNotFound
          api_error!(20302)
        rescue FrequentRequest
          api_error!(20301)
        rescue TooManyRequest
          api_error!(20315)
        rescue InvalidUserType
          api_error!(20316)
        end
      end
    end
  end
end
