# -*- encoding : utf-8 -*-
class Caddie::BaseController < ApplicationController
  layout 'caddie'

  before_action :authenticate
  
  def authenticate
    redirect_to cms_signin_path if session['user'].blank?
  end
end