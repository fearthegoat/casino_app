## To Do list
## [] Multiple decks
## [] Basic Strategy
## [] Payouts for $$$


class Card

  attr_accessor :value
  attr_reader :name

  def initialize(name, value, suit)
    @name = name
    @suit = suit
    @value = value
  end

  def to_s
    "#{@name} of #{@suit}"
  end
end

class StackOfCards
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def shuffle
    @cards.shuffle!
  end

  def add_card(card)
    @cards << card
  end

  def set_ace_value_to_1
    @cards.each do |card|
      card.value = 1 if card.name == "Ace"
    end
  end

  def a_pair?
    return false unless @cards.size == 2 # pair must have only 2 cards in the stackofcards
    a_pair = []
    @cards.each do |card|
      a_pair << card.name
    end
    a_pair[0] == a_pair[1]
  end

  def ace_present?
    @cards.each do |card|
      return true if card.name == "Ace"
    end
    return false
  end

  def blackjack?
    return true if @cards.total_value == 21 && @cards.size == 2
      return false
  end

  def count
    @cards.count
  end

  def total_value
    @cards.inject(0) { |total, card| total + card.value }
  end

  def deal_off_top_to(other_stack, number_of_cards = 1)
    number_of_cards.times do
      card = @cards.shift
      other_stack.add_card(card)
    end
  end

  def to_s
    puts @cards.map { |c| c.to_s }.join(', ')
  end
end


class Deck < StackOfCards
  SUITS = "Spades", "Clubs", "Diamonds", "Hearts"
  NAMES =  "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"

  def initialize
    super # "super" will call the parent version of initialize (e.g. initialize defined in StackOfCards)

    SUITS.each do |s|
      NAMES.each.with_index do | name, index|
        index += 2 # Needed since index starts at 0.  Ace is assumed to have value of 14 instead of 1
        index >= 10 ? index = 10 : index  #doesn't solve the Ace problem.
        name == "Ace" ? index = 11 : nil
        @cards << Card.new(name, index, s)
      end
    end
    @cards
  end

end

class Card_Player
  attr_accessor :cash
  attr_accessor :current_bet
  attr_accessor :cards
  attr_accessor :name
  attr_accessor :hands

  def initialize(name = "monkey", money = 500)
    @name = name
    @cash = money
    @hands = []
    @initial_hand = StackOfCards.new
    @hands << @initial_hand
  end

  def bet(bet_amount)
    @current_bet = bet_amount
  end

  def blackjack
    @cash += @current_bet * 1.5
  end

  def wins
    @cash += @current_bet
  end

  def loses
    @cash -= @current_bet
  end
end


def build_player_hand_with_no_ace(current_player)
  if current_player.total_value >= 17 ||  current_player.total_value >= 13 && @dealer.total_value <= 6 || current_player.total_value == 12 && @dealer.total_value <= 6 && @dealer.total_value >= 4 # The "Standard Strategy" for blackjack
    return
  else
    @deck.deal_off_top_to(current_player, 1)
    build_player_hand_with_ace(current_player) and return if current_player.ace_present?
    build_player_hand_with_no_ace(current_player)
    return
  end
end

def build_player_hand_with_ace(current_player)

  if current_player.ace_present? && current_player.total_value >= 22
    current_player.set_ace_value_to_1
    build_player_hand_with_no_ace(current_player)
    return
  end
  if current_player.total_value >= 19 ||  current_player.total_value >= 18 && @dealer.total_value <= 8
    return
  else
    @deck.deal_off_top_to(current_player, 1)
    build_player_hand_with_ace(current_player)
  end
end

def outcome(current_player)
  current_player.hands.each do |hand|
    if hand.total_value == 21 && hand.count == 2
      current_player.blackjack
    elsif hand.total_value > 21
      current_player.loses
    elsif @dealer.total_value > 21
      current_player.wins
    elsif hand.total_value > @dealer.total_value
      current_player.wins
    elsif hand.total_value < @dealer.total_value
      current_player.loses
    else
      nil # push
    end
  end
end

def splittable?(hand)
  hand.a_pair? and not (hand.total_value == 20 || hand.total_value == 18 && (@dealer.total_value == 7 || @dealer.total_value >=10) || hand.total_value <= 14 && @dealer.total_value >=8 || hand.total_value == 10 || hand.total_value ==8 && @dealer.total_value <=4 || hand.total_value <= 12 && hand.total_value >= 8 && @dealer.total_value == 7)
end

def split_hand(hand, player)
  new_hand = StackOfCards.new
  hand.deal_off_top_to(new_hand ,1)
  @deck.deal_off_top_to(hand,1)
  @deck.deal_off_top_to(new_hand,1)
  player.hands << new_hand
end
# [ [ACE,ACE] ]

def play_game(player, bet)
  @dealer = StackOfCards.new
  current_player = Card_Player.new(player.name, player.money)
  @deck = Deck.new
  @deck.shuffle
  current_player.bet(bet)
  @deck.deal_off_top_to(@dealer, 1)
  @deck.deal_off_top_to(current_player.hands.first, 2)

  current_player.hands.each do |hand|
    if current_player.hands.size < 4
      split_hand(hand, current_player) if splittable?(hand)
    end
  end

  current_player.hands.each do |hand|
    if hand.ace_present?
      build_player_hand_with_ace(hand)
    else
      build_player_hand_with_no_ace(hand)
    end
  end

  while @dealer.total_value <= 16
    @deck.deal_off_top_to(@dealer, 1)
    if @dealer.ace_present? && @dealer.total_value >= 22
      @dealer.set_ace_value_to_1
    end
  end

  outcome(current_player)
  @money_tracker << current_player.cash
  player.money = current_player.cash
  player.save
end
