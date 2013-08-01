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

	# def show
	# end

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

	respond_to do |format|
		if @session.save
			format.html { redirect_to session_admin_index_path(@session), notice: 'Session was successfully created.' }
			format.json { render action: 'show', status: :created, location: @session }
		else
				format.html { render action: 'new' }
				format.json { render json: @session.errors, status: :unprocessable_entity }
		end
	end
  end

  def session_update
	respond_to do |format|
	  if @session.update(session_params)
	    format.html { redirect_to session_admin_index_path(@session), notice: 'Session was successfully updated.' }
		format.json { head :no_content }
	  else
		format.html { render action: 'edit' }
		format.json { render json: @session.errors, status: :unprocessable_entity }
	  end
	end
  end

  def session_destroy
    if @session.destroy
      redirect_to sessions_admin_index_path
    end
	# respond_to do |format|
	#   format.html { redirect_to sessions_admin_index_path}
	#   format.json { head :no_content }
	# end
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

	respond_to do |format|
	  if @expert.save
		format.html { redirect_to expert_admin_index_path(@expert), notice: 'Expert was successfully created.' }
		format.json { render action: 'show', status: :created, location: @expert }
	  else
		format.html { render action: 'new' }
		format.json { render json: @expert.errors, status: :unprocessable_entity }
	  end
	end
  end

  def expert_update
    respond_to do |format|
	  if @expert.update(expert_params)
		format.html { redirect_to expert_admin_index_path(@expert), notice: 'Expert was successfully updated.' }
		format.json { head :no_content }
	  else
		format.html { render action: 'edit' }
		format.json { render json: @expert.errors, status: :unprocessable_entity }
	  end
	end
  end

  def expert_destroy
	@expert.destroy
	respond_to do |format|
		format.html { redirect_to experts_admin_index_url }
		format.json { head :no_content }
	end
  end

  private
    def set_session
	  @session = Session.find(params[:id])
	end

	def session_params
		params.require(:session).permit(:title, :expert_id, :created_date, :description)
	end

	def set_expert
		@expert = Expert.find(params[:id])
	end

	def expert_params
		params.require(:expert).permit(:name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
	end
end
