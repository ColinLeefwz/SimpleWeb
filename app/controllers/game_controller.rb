class GameController < ApplicationController
  
  def new_score
    @game = Game.new(params[:game])
    if @game.save
     games =  Game.where({gid: @game.gid, sid: @game.sid}).sort({score: -1}).limit(5)
     data = games.map{|m|  {uid: m.uid, uname: m.user_name, score: m.score }}


    else
      data={}
    end

    render :json => data.to_json

  end
  
end
