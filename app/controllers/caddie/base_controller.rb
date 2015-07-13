# -*- encoding : utf-8 -*-
class Caddie::BaseController < ApplicationController
  layout 'caddie'

  before_action :authenticate
  
  def authenticate
    redirect_to caddie_signin_path if session['caddie'].blank?
  end
end