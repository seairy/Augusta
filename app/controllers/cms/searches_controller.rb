# -*- encoding : utf-8 -*-
class Cms::SearchesController < Cms::BaseController
  
  def show
    @courses = Course.where("name LIKE '%#{params[:keyword]}%'").page(params[:page])
  end
end
