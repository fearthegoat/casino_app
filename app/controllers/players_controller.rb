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

    @money_tracker = []  # used to track the change in player's money over the games played
    @games_tracker = []  # used to track the number of games played
    @money_tracker << @player.money
    @game_counter = 0

    params[:games].to_i.times do
      if @bid > @player.money
        redirect_to root_url
        flash[:notice] = "Bet", "must be less than #{@player.money}"
        break
      else
        play_game(@player, @bid)
        @game_counter += 1
      end
    end

    i = 0
    (@game_counter+1).times do
      @games_tracker << i
      i += 1
    end
    @min_amount = @money_tracker.min
    @max_amount = @money_tracker.max
    @standard_deviation = standard_deviation(@money_tracker)
    @chart_hash =  @games_tracker.zip(@money_tracker)
    # @chart_hash = [ {name: "Trav", data: {1 => 1809, 2 => 1810, 3 => 1820} }, {name: "Kevin", data: {1 => 1830, 2 => 1820, 3 => 1810} } ]
      render 'game.js.erb'
  end

  def standard_deviation(array)
    sum = array.inject(0.0) { | result, value | result + value}
    average = sum / array.size
    variance = (array.inject(0.0) { | total, result | total + (average - result)**2}) / array.size
    Math.sqrt(variance)
  end

end
