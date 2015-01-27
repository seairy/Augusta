module V1API
  class User < Grape::API
    resources :users do
      desc '用户注册'
      post :sign_up do
        present uuid: SecureRandom.uuid
      end
    end
  end
end