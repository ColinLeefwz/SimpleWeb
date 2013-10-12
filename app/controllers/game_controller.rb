class GameController < ApplicationController
  
  def new_score
    @game = Game.new(params[:game])
    if @game.save_redis
     games = $redis.zrevrange(@game.redis_key,0,5,withscores:true)
     data = games.map{|x| {uid: x[0], uname: User.find_by_id(x[0]).name, score: x[1] } }
    else
      data={}
    end

    render :json => data.to_json

  end
  
end
