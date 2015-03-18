# -*- encoding : utf-8 -*-
class Cms::SearchesController < Cms::BaseController
  
  def show
    @venues = []
    Province.where("name LIKE '%#{params[:keyword]}%'").each do |province|
      province.cities.each do |city|
        city.venues.each do |venue|
          @venues << venue
        end
      end
    end
    @venues << City.where("name LIKE '%#{params[:keyword]}%'").map do |city|
      city.venues.each do |venue|
        @venues << venue
      end
    end
    @venues << Venue.where("name LIKE '%#{params[:keyword]}%'").to_a
    @venues.flatten!.uniq!
  end
end
