class Player < ActiveRecord::Base

  attr_accessor :bet
  attr_accessor :games

  def to_s
    "#{name}"
  end

end
