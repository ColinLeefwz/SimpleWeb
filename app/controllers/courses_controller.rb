class CoursesController < ApplicationController
  load_and_authorize_resource

  before_action :set_course, except: [:index, :new, :create]

  def index
    @courses = Course.all
  end

  def show
    @course.intro_video || @course.create_intro_video
  end

  def new
    @course = Course.new
    @course.build_intro_video
  end

  # todo: add error handler
  def create
    @course = Course.create(course_params)
    redirect_to preview_course_path(@course)
  end

  def edit
    @course.intro_video || @course.create_intro_video
  end

  def update
    if @course.update_attributes course_params
      redirect_to preview_course_path(@course), flash: {success: "Update Successfully"}
    else
      redirect_to preview_course_path(@course), flash: {error: "Failed to Update"}
    end
  end

  def destroy
    # todo: add error handling
    @course.destroy
    redirect_to courses_path
  end

  def preview
  end

  def enroll
    render "courses/enroll", locals: {item: @course}
    # todo: detect user_signed_in? after click the payment button
  end

  def enroll_confirm
    current_user.enroll(@course)
    send_enrolled_mail(@course)
    redirect_to @course, flash: {success: "Subscribed successfully!"}
  end

  def purchase
    order = Order.create(user: current_user, enrollable: @course)
    order.create_payment(@course, execute_order_url(order))
    redirect_to order.approve_url
  end

  # todo: use Exception and Catch mechanism to deal with all accidents(maybe in the application_controller)
  def sign_up_confirm
    member = Member.create(member_params)
    sign_in member

    if @course.free?
      redirect_to enroll_confirm_course_path(@course)
    else
      redirect_to purchase_course_path(@course)
    end

  end


  private
  def member_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :time_zone)
  end

  def set_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit(:id, :title, :description, :cover, :price, {categories:[]}, {expert_ids: []}, chapters_attributes: [:id, :title, :description, :order, :_destroy, sections_attributes: [:id, :title, :description, :duration, :order, :free_preview, :_destroy] ], intro_video_attributes: [:attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :hd_url])
  end
end
