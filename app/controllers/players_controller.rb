class PlayersController < ApplicationController
  def show
  end

  def index
    @players = Player.all
    @player = Player.new
  end

  def game
    @bid = params[:bid].to_i
    @player = Player.find(params[:players])
    raise :oops
    play_game(@player, @bid)

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
