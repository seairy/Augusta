# -*- encoding : utf-8 -*-
class Cms::SearchesController < Cms::BaseController
  
  def show
    @courses = []
    Province.where("name LIKE '%#{params[:keyword]}%'").each do |province|
      province.cities.each do |city|
        city.courses.each do |course|
          @courses << course
        end
      end
    end
    @courses << City.where("name LIKE '%#{params[:keyword]}%'").map do |city|
      city.courses.each do |course|
        @courses << course
      end
    end
    @courses << Course.where("name LIKE '%#{params[:keyword]}%'").to_a
    @courses.flatten!.uniq!
  end
end
