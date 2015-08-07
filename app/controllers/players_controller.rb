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

    if @bid > @player.money
      redirect_to root_url
      flash[:notice] = "Bet", "must be less than #{@player.money}"
      return
    end
    @money_tracker = []  # used to track the change in player's money over the games played
    play_game(@player, @bid)
    respond_to do |format|
      format.js
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
