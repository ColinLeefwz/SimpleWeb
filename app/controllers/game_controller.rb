class GameController < ApplicationController
  
  def new_score
    @game = Game.new(params[:game])
    if @game.save
      
    else
      
    end
  end
  
end
