# -*- encoding : utf-8 -*-
class Cms::BaseController < ApplicationController
  layout 'cms'

  before_action :authenticate
  before_action :find_notifications

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  protected
  def render_error status, exception
    Error.create(caller: "Administrator-#{session['administrator']['id']}", name: exception.class.to_s, message: exception.message, backtrace: "<p>#{exception.backtrace.try(:join, '</p><p>')}</p>")
    render template: "cms/errors/error_#{status}", status: status
  end
  
  def authenticate
    redirect_to cms_signin_path if session['administrator'].blank?
  end
  
  def find_notifications
    @unread_notifications_count = Notification.by_administrator(session['administrator']['id']).unread.count
    @unread_notifications_count = '99+' if @unread_notifications_count > 99
    @dropdown_notifications = Notification.by_administrator(session['administrator']['id']).unread.sorted.limit(5)
  end
end
