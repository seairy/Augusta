# -*- encoding : utf-8 -*-
class Cms::DashboardController < Cms::BaseController
  
  def index
    @users_count = User.count
    @guests_in_users_count = ((User.guests.count.to_f / User.count) * 100).round(2)
    @members_in_users_count = ((User.members.count.to_f / User.count) * 100).round(2)
    @venues_count = Venue.count
    @courses_count = Course.count
    @holes_count = Hole.count
  end
end
