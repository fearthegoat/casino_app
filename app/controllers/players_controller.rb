class PlayersController < ApplicationController
  def show
  end

  def index
    @players = Player.all
    @player = Player.new
  end

  def game

    @player = Player.find(params[:players])
    play_game(@player, 50)

    respond_to do |format|
      format.json { render json: Player.find(params[:players]).money }
    end
  end

  def edit
  end

  def update
  end

  def create
  end

  def new
  end

  def destroy
  end
end
