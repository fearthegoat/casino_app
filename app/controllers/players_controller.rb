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
      @players << Player.find(params[:players])
    end
    play_games(@players, @bid, params[:games].to_i)
    # render 'game.js.erb'
  end

  def play_games(players, bid, number_of_games)
    number_of_games.times do
      generate_deck
      create_dealer
      players.each do |player|
        if bid > player.money
          break
        else
        player_generate_hand(player, bid, @dealer)
        end
      end
      finish_dealer_hand
      players.each do |player|
        break if player.cards.size == 0
        outcome(player)
      # @outcomes << [100,150,150]
      end
    end
    # @outcomes_parsing
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
    # @chart_hash = [ {name: "Trav", data: {0 => 1809, 1 => 1810, 2 => 1820} }, {name: "Kevin", data: {1 => 1830, 2 => 1820, 3 => 1810} } ]
    #


  def standard_deviation(array)
    sum = array.inject(0.0) { | result, value | result + value}
    average = sum / array.size
    variance = (array.inject(0.0) { | total, result | total + (average - result)**2}) / array.size
    Math.sqrt(variance)
  end

end
