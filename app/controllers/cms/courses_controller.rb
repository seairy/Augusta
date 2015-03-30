# -*- encoding : utf-8 -*-
class Cms::CoursesController < Cms::BaseController
  before_action :find_venue, only: [:new, :create]
  
  def index
    @courses = Course.page(params[:page])
  end
  
  def show
    @course = Course.find(params[:id])
  end
  
  def new
    @course = Course.new
  end
  
  def edit
    @course = Course.find(params[:id])
  end
  
  def create
    @course = Course.new(course_params)
    @course.venue = @venue
    if @course.save
      @course.create_holes_and_tee_boxes! params[:holes_count].to_i
      redirect_to [:cms, @venue], notice: '创建成功！'
    else
      render action: 'new'
    end
  end
  
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      redirect_to [:cms, @course.venue], notice: '更新成功！'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @course = Course.find(params[:id])
    @course.trash
    redirect_to cms_courses_path, notice: '删除成功！'
  end

  protected
  def find_venue
    @venue = Venue.find(params[:venue_id])
  end

  def course_params
    params.require(:course).permit!
  end
end
