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
      player_data_hash = Hash[((1..player_array.size).to_a).zip(player_array)]

      player_hash.merge!(data: player_data_hash)
      player_hash.merge!(name: player.name)
      @chart_array << player_hash
      player_number +=1
    end
  end

  def generate_deck
    @deck = Deck.new
    @deck.shuffle
  end

  def create_dealer
    @dealer = StackOfCards.new
    @deck.deal_off_top_to(@dealer, 1)
  end




    # @min_amount = @money_tracker.min
    # @max_amount = @money_tracker.max
    # @standard_deviation = standard_deviation(@money_tracker)
    # # @chart_hash =  @games_tracker.zip(@money_tracker)
    # @chart_array = [ {name: "Trav", data: {0 => 1809, 1 => 1810, 2 => 1820} }, {name: "Kevin", data: {1 => 1830, 2 => 1820, 3 => 1810} } ]


  def standard_deviation(array)
    sum = array.inject(0.0) { | result, value | result + value}
    average = sum / array.size
    variance = (array.inject(0.0) { | total, result | total + (average - result)**2}) / array.size
    Math.sqrt(variance)
  end

end
