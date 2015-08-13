class PlayersController < ApplicationController
  def show
  end

  def index
    @players = Player.all
    @player = Player.new
  end

  def game
    @bid = params[:bid].to_i
    if params[:all] == "1"
      @players = Player.all
    else
      @players = []
      @players << Player.find(params[:players])
    end
    play_games(@players, @bid, params[:games].to_i)
    render 'game.js.erb'
  end

  def play_games(players, bid, number_of_games)
    @game_results = []  #stores data for analysis
    players.each { | player | @game_results << player.money }
    number_of_games.times do
      generate_deck
      create_dealer
      finish_dealer_hand
      players.each do |player|
        if bid > player.money
          break
        else
        player_generate_hand(player, bid, @dealer)
        end
      end
    end
    player_number = 0
    @chart_array = []
    players.each do |player|
      player_array = []
      player_hash = Hash.new
      @game_results.each_with_index do |number, i|
        unless i >= @game_results.size / players.size
          array_index = player_number + (i)*players.size
          player_array << @game_results[array_index]
        end
      end
      player_array_indexed = player_array.map { |number| number - player_array[0]}
      generate_trend(player_array_indexed)
      player_data_hash = Hash[((0..player_array.size).to_a).zip(player_array_indexed)]

      player_hash.merge!(data: player_data_hash)
      player_hash.merge!(name: player.name)
      @chart_array << player_hash
      player_number +=1
    end
  end

  # def generate_trend(array)
  #   trying to figure out how to build regression
  #   y = mx + b
  #   a.size times do
  #     i += 1
  #     slope = ( a[-i] - a[i-1] ) / (a.size - i + 1)
  #     10.times do
  #
  #     end
  #   slope
  #   end
  # end

  def generate_deck
    @deck = Deck.new
    @deck.shuffle
  end

  def create_dealer
    @dealer = StackOfCards.new
    @deck.deal_off_top_to(@dealer, 1)
  end

  # leftover analytics from old verison

  # @min_amount = @money_tracker.min
  # @max_amount = @money_tracker.max
  def standard_deviation(array)
    sum = array.inject(0.0) { | result, value | result + value}
    average = sum / array.size
    variance = (array.inject(0.0) { | total, result | total + (average - result)**2}) / array.size
    Math.sqrt(variance)
  end

end
