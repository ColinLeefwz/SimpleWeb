require 'spec_helper'

describe AdminController do
  helper_objects
  
  describe "GET sign in" do
    it "render 'sign_in' page" do
      get :sign_in
      expect(response).to render_template("sign_in")
    end
  end

  describe "POST authorize" do
  	
  	context "authorize fails" do
  	  it "redirect back to sign in page" do
        admin = {username: 'sameer', password: '321'}
  	    post :authorize, admin: admin
  	    expect(response).to redirect_to(sign_in_admin_index_url)
      end
    end

    context "authorize successes" do
  	  it "works fine and render the 'index' page" do
  	    admin = {username: 'sameer', password: '123'}
  	    post :authorize, admin: admin
  	    response.should be_success
  	    response.should render_template("index")
      end
    end
  end


  describe "GET index" do
   
    context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :index
      	response.should redirect_to sign_in_admin_index_url
      end
    end
    
    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "render 'index' page" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end

  describe "GET session_index" do
  	context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_index
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "assigns @sessions" do
      	sessions = Session.all
      	get :session_index
      	expect(assigns(:sessions)).to eq(sessions)
      end

      it "go to 'index' page" do
      	get :session_index
      	response.should render_template('session_index')
      end
    end
  end

  describe "GET session_show" do
  	context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_show, id: first_session.id
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "go to 'show' page" do
      	get :session_show, id: first_session.id
      	response.should render_template('session_show')
      end
    end
  end
  
  describe "GET session_new" do
  	context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_new
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "go to 'new' page" do
      	get :session_new
        assigns[:session].should be_new_record  
      end
    end    
  end

  describe "GET session_edit" do
  	context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_edit, id: first_session.id
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "goes to 'session_edit' page" do
      	get :session_edit, id: first_session.id
        response.should render_template('session_edit')
      end
    end    
  end

  describe "POST session_create" do
  	context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	post :session_create
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
      	session[:login] = true
      end

      it "creates new session for expert" do
        expect{post :session_create, session: {title: "blabla", expert: petter}}.to change{Session.count}.by(1)
      end
    end    
  end
  

  describe "PUT session_update" do
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        put :session_update, id: first_session.id
        response.should redirect_to sign_in_admin_index_url
      end
    end 

    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "updates the attribute of expert" do
        expect{put :session_update, id: first_session.id, session: { title: 'test'}}.to change{first_session.reload.title}.from('Intro Session to Lean Start-Up').to('test')
      end
    end
  end

  describe "DELETE session_destroy" do
    context "have not signed in" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	post :session_destroy, id: first_session.id
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do 
      it "deletes a session" do
        first_session.save
        expect{delete :session_destroy, id: first_session.id}.to change{Session.count}.by(-1)
      end
    end
  end


  describe "GET expert_index" do
    context "have not signed in" do
      it "go back to 'sign in' page" do
        session[:login] = nil
        get :expert_index
        response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "assigns @experts" do
        experts = Expert.where(authorized: true)
        get :expert_index
        expect(assigns[:experts]).to eq(experts)
      end

      it "render 'expert_index' page" do
        get :expert_index
        response.should render_template('expert_index')
      end
    end
  end

  describe "GET expert_show" do
    context "have not signed in" do  
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_show, id: petter.id
        response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
        session[:login] = true
      end
      
      it "render the 'expert_show' page" do
        get :expert_show, id: petter.id
        response.should render_template('expert_show')
      end
    end
  end

  describe "GET expert_new" do
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_new
        response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "assigns @epxert" do
        get :expert_new
        assigns[:expert].should be_new_record
      end

      it "render 'expert_new' page" do
        get :expert_new
        response.should render_template('expert_new')
      end
    end
  end        

  describe "GET expert_edit" do 
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_edit, id: petter.id
        response.should redirect_to sign_in_admin_index_url
      end
    end

    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "render 'expert_edit' page" do
        get :expert_edit, id: petter.id
        response.should render_template('expert_edit')
      end
    end
  end

  describe "POST expert_create" do
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_create
        response.should redirect_to sign_in_admin_index_url
      end
    end 
    
    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "create a new expert" do
        expect{post :expert_create, expert: {name: 'test'}}.to change{Expert.count}.by(1)
      end
    end
  end

  describe "PUT expert_update" do
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_update, id: petter.id
        response.should redirect_to sign_in_admin_index_url
      end
    end 

    context "have signed in" do
      it "updates the attribute of expert" do
        expect{put :expert_update, id: petter.id, expert: { company: 'test'}}.to change{petter.reload.company}.from('Prodygia').to('test')
      end
    end
  end
  
  describe "DELETE expert_destroy" do
    context "have not signed in" do
      it "goes back to 'sign in' page" do
        session[:login] = nil
        get :expert_destroy, id: petter.id
        response.should redirect_to sign_in_admin_index_url
      end
    end 

    context "have signed in" do
      before :each do
        session[:login] = true
      end

      it "deletes one expert" do
        petter.save
        expect{delete :expert_destroy, id: petter.id}.to change{Expert.count}.by(-1)
      end
    end
  end
end
