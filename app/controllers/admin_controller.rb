class AdminController < ApplicationController
  before_action :set_session, only: [:session_show, :session_edit, :session_update, :session_destroy]
  before_action :set_expert, only: [:expert_show, :expert_edit, :expert_update, :expert_destroy]
  before_action :check, except: [:sign_in, :authorize]

  def index
  end


  def authorize
	username = params[:admin][:username]
	password = params[:admin][:password]
	logger.info "username is #{username}"
	logger.info "password is #{password}"
	if (username == 'sameer') && (password == '123')
		session[:login] = true
		render 'index'
	else
		redirect_to sign_in_admin_index_path
	end
  end


  def sign_in
  end


  def session_index
	@sessions = Session.all
  end


  def session_show
  end


  def session_new
	@session = Session.new
  end


  def session_edit
  end


  def session_create
	@session = Session.new(session_params)
	if @session.save
	  redirect_to session_admin_index_path(@session)
	else
	  render action: 'session_new'
	end
  end


  def session_update
	if @session.update(session_params)
	  redirect_to session_admin_index_path(@session)
	else
	  render action: 'session_edit'
	end
  end


  def session_destroy
    @session.destroy
		redirect_to sessions_admin_index_path
  end


  def expert_index
    @experts = Expert.where(authorized: true)
  end


  def expert_show
  end


  def expert_new
	@expert = Expert.new
  end


  def expert_edit
  end


  def expert_create
	@expert = Expert.new(expert_params)
	if @expert.save
      redirect_to expert_admin_index_path(@expert)
	else
	  render action: 'expert_new'
	end
  end


  def expert_update
	if @expert.update(expert_params)
	  redirect_to expert_admin_index_path(@expert)
	else
	  render action: 'expert_edit'
	end
  end


  def expert_destroy
	@expert.destroy
    redirect_to experts_admin_index_url
  end


  private
    def set_session
	  @session = Session.find(params[:id])
	end

	def session_params
		params.require(:session).permit(:title, :expert_id, :description)
	end

	def set_expert
		@expert = Expert.find(params[:id])
	end

	def expert_params
		params.require(:expert).permit(:name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
	end
end
