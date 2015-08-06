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
