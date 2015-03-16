# -*- encoding : utf-8 -*-
class Sim::BaseController < ApplicationController
  layout 'sim'

  before_action :authenticate
  
  def authenticate
    session['user'] = User.guests.first if session['user'].blank?
  end
end
