# -*- encoding : utf-8 -*-
class Frontend::HomeController < Frontend::BaseController
  def index

  end

  def get
    platform = if !!(request.user_agent.downcase =~ /iphone/) or !!(request.user_agent.downcase =~ /ipad/)
      'ios'
    elsif !!(request.user_agent.downcase =~ /android/)
      'android'
    else
      'unknown'
    end
    Scan.create!(ip: request.remote_ip, source: params[:source], platform: platform)
    render layout: false
  end
end