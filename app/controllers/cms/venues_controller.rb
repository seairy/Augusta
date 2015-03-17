# -*- encoding : utf-8 -*-
class Cms::VenuesController < Cms::BaseController
  
  def index
    @venues = Venue.page(params[:page])
  end
  
  def show
    @venue = Venue.find(params[:id])
  end
  
  def new
    @venue = Venue.new
  end
  
  def edit
    @venue = Venue.find(params[:id])
  end
  
  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to [:cms, @venue], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(venue_params)
      redirect_to [:cms, @venue], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @venue = Venue.find(params[:id])
    @venue.trash
    redirect_to cms_venues_path, notice: '删除成功！'
  end

  protected
  def venue_params
    params.require(:venue).permit!
  end
end
