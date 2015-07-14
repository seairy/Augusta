# -*- encoding : utf-8 -*-
class Caddie::BaseController < ApplicationController
  layout 'caddie'

  before_action :authenticate
  
  def authenticate
    if session['caddie'].blank?
      redirect_to caddie_signin_path
    else
      @current_caddie = Caddie.find(session['caddie']['id'])
    end
  end
end