class Player < ActiveRecord::Base

  attr_accessor :bet

  def to_s
    "#{name}"
  end


end
