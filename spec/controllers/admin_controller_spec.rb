require 'spec_helper'

describe AdminController do
  
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
   
    context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :index
      	response.should redirect_to sign_in_admin_index_url
      end
    end
    
    context "signed in user" do
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
  	context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_index
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "signed in user" do
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
  	context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	first_session = Session.first
      	get :session_show, id: first_session.id
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "signed in user" do
      before :each do
      	session[:login] = true
      end

      it "go to 'show' page" do
      	first_session = Session.first
      	get :session_show, id: first_session.id
      	response.should render_template('session_show')
      end
    end
  end
  
  describe "GET session_new" do
  	context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_new
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "signed in user" do
      before :each do
      	session[:login] = true
      end

      it "go to 'new' page" do
      	session = Session.new
      	get :session_new
        session.should be_new_record  
      end
    end    
  end

  describe "GET session_edit" do
  	context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	get :session_edit
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "signed in user" do
      before :each do
      	session[:login] = true
      end

      it "go to 'new' page" do
      	get :session_edit
        response.should render_template('edit')
      end
    end    
  end

  describe "POST session_create" do
  	context "not signed in user" do
      it "go back to 'sign in' page" do
      	session[:login] = nil
      	post :session_create
      	response.should redirect_to sign_in_admin_index_url
      end
    end

    context "signed in user" do
      before :each do
      	session[:login] = true
      end

      it "creates new session for expert"  

    end    
  end
  

  describe "PUT session_update"

    describe "DELETE session_destroy" do
      context "not signed in user" do
        it "go back to 'sign in' page" do
      	  session[:login] = nil
      	  post :session_destroy
      	  response.should redirect_to sign_in_admin_index_url
        end
      end

      context "signed in user" 
    end





end
