
$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  

class Oauth2Controller < ApplicationController

  def sina_new
    
  end


  def sina_callback
    data = {:seq => 12345, :code => params[:code] }
	  render :json => data.to_json
  end
  
end
