class Player < ActiveRecord::Base

  attr_accessor :bet
  attr_accessor :games
  attr_accessor :all

  def to_s
    "#{name}"
  end

end
