class ExpertsController < ApplicationController
  load_and_authorize_resource

  def sessions
    @sessions = @expert.sessions.order("draft desc")
    @from = 'sessions'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def dashboard
    @sessions = @expert.sessions.order("draft desc")
  end

  def new_post_content
    @article_session = Session.new  # use Session.new so that form params are wrapped in :session
    @from = 'new_post_content'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def create_post_content
    @article_session = ArticleSession.new(session_params)
    @article_session.expert = current_user
    case params[:commit]
    when "Save draft"
      @article_session.draft = true
      save_session(@article_session)
    when "Preview"
      @article_session.draft = true
      if @article_session.save
        redirect_to session_path(@article_session)
      end
    when "Createe post content"
      save_session(@article_session)
    end

  end

  def new_live_session
    @live_session = Session.new
    @from = 'new_live_session'
    respond_to do |format|
      format.js { render 'update'}
    end
  end


  def create_live_session
    @live_session = LiveSession.new(session_params)
    @live_session.expert = current_user

    case params[:commit]
    when "Save Draft"
      @live_session.draft = true
      notice = "Draft Saved"
    when "Preview"
    when "Submit"
      notice = "successful"
    end

    if @live_session.save
      redirect_to dashboard_expert_path(current_user), notice: notice
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end

  def pending_page
    @from = 'pending_page'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def refer_new_expert
    @expert = current_user
    message_content = <<CONTENT
    <p>Dear [FIRST NAME_RECIPIENT EXPERT],</p>

    <p>I’m using a new site to read and display quality content on China and thought I’d share with you.</p>

    <p>It’s called Prodygia. What’s different with their model is that they start with experts, like you and me, and give us a toolkit to promote our knowledge on China and get paid. You can record on-demand video sessions and sell them to your network or run live sessions online. It’s quite unique and innovative in the market. They are carving out a niche for expertise on business, entrepreneurship, technology and culture as they relate to China.</p>

    <p>I encourage you to learn more about the platform and see how you can capitalize on it to build your online presence.</p>
    <p>Click below to sign up and enter your profile. It’s a first step. You can actually save time by signing up from your LinkedIn or Facebook accounts. Feel free to email specific questions to the Prodygia team on<a href="mailto:experts@prodygia.com"> experts@prodygia.com. </a>
    <p>Sincerely,</p>

    <p>[FIRST NAME_SENDER EXPERT]</p>
CONTENT

    @email_message = current_user.email_messages.build(subject: "Invite you to be expert at Prodygia", message: message_content, from_name: "#{current_user.first_name} #{current_user.last_name}", from_address: "no-reply@prodygia", reply_to: "#{current_user.email}")
  end

  private
  def set_expert
    @expert = Expert.find(params[:id])
  end


  def session_params
    params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date )
  end

  def expert_params
    params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
  end

  def save_session(session)
    if session.save
      redirect_to dashboard_expert_path(current_user), notice: 'successful'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end
end
