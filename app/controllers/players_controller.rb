class PlayersController < ApplicationController
  def show
  end

  def index
    @players = Player.all
    @player = Player.new
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
