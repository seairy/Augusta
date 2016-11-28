# -*- encoding : utf-8 -*-
module V1
  class FeedbacksAPI < Grape::API
    resources :feedbacks do
      desc '意见反馈'
      params do
        requires :content, type: String, desc: '内容'
      end
      post '/' do
        Feedback.create!(user: @current_user, content: params[:content])
        present successful_json
      end
    end
  end
end
