class GameController < ApplicationController
  
  def new_score
    
    
    @game = Game.new(params[:game])
    if @game.save_redis
      games = $redis.zrevrange(@game.redis_key,0,4,withscores:true)
      @data = games.map{|x| {uid: x[0], uname: User.find_by_id(x[0]).name, score: x[1].to_i } }
      rank =  $redis.zrevrank(@game.redis_key,@game.uid)
      @rank = rank && rank+1
    else
      @data=[]
      @rank=nil
    end

    @data=[{uid: "test1", uname: 'test1234234', score: "63"},{uid: "test1", uname: 'testdsf1', score: "3"},{uid: "test1", uname: 'testdsf1', score: "33"},{uid: "test1", uname: 'testdsf1', score: "3"},{uid: "tedst1", uname: 'test1', score: "1"}] if ENV["RAILS_ENV"] != "production"

  end
  
end
