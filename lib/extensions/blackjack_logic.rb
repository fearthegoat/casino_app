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
    ace_cards = []
    @cards.each do |card|
      card.value = 1 if card.name == "Ace"
    end
  end

  def a_pair?
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

  def initialize(name = "monkey", money = 500)
    @name = name
    @cash = money
    @cards = StackOfCards.new
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

### Need to build a proper basic strategy chart here
### Inputs are (1) Dealer's up card and (2) Player's hand
### Use slice with Dealer's up card???


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

## Define players and dealer
# travis = Card_Player.new("Travis", 700)
# kevin = Card_Player.new("Kevin", 600)
# dog = Card_Player.new

# PLAYERS = travis, kevin, dog
@dealer = StackOfCards.new

# Display everyone's stacks and get bets
puts "Current stacks:"

PLAYERS.each do |person|
  puts "#{person.name}: #{person.cash}"
end

PLAYERS.each do |person|
  print "#{person.name} bet: "
  bet_amount = gets.chomp
  person.bet(bet_amount.to_i)
end

# Create a deck and shuffle it
@deck = Deck.new
@deck.shuffle

# Deal the cards to dealer and players
@deck.deal_off_top_to(@dealer, 1)

PLAYERS.each do |person|
  @deck.deal_off_top_to(person.cards, 2)
end

print "dealer: "
puts "#{(@dealer).to_s}"

PLAYERS.each do |person|
  print "#{person.name}: "
  print "#{person.cards.to_s}"
  puts "#{person.name}'s total value: #{person.cards.total_value} "
  puts ""
end

PLAYERS.each do |person|
  if person.cards.ace_present?
    build_player_hand_with_ace(person.cards)
  else
    build_player_hand_with_no_ace(person.cards)
  end
end

# Deals the dealer's hand -- assumes dealer stands on soft 17
# Should be <= 16
while @dealer.total_value <= 16
  @deck.deal_off_top_to(@dealer, 1)
end

puts "dealer: "
puts "#{@dealer.to_s}"
puts "dealer total_value: #{@dealer.total_value}"
puts ""

PLAYERS.each do |person|
  print person.name, ": "
  print "#{person.cards.to_s}"
  print person.name, " total value: ", person.cards.total_value, "\n\n"
end

## Code to determine who wins
PLAYERS.each do |person|
  if person.cards.total_value == 21 && person.cards.count == 2
    puts "Blackjack for ", person.name
    person.blackjack
  elsif person.cards.total_value > 21
    puts "#{person.name} Busts"
    person.loses
  elsif @dealer.total_value > 21
    puts "Dealer Busts"
    person.wins
  elsif person.cards.total_value > @dealer.total_value
    puts "#{person.name} Wins"
    person.wins
  elsif person.cards.total_value < @dealer.total_value
    puts "Dealer Wins"
    person.loses
  else
    puts "Push"
  end
end

puts "Current stacks:"

PLAYERS.each do |person|
  print person.name, ": ", person.cash, "\n"
end
