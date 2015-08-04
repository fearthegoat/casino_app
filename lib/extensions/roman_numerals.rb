class Integer

  NUMBER_TO_ROMAN_MAPPING = {
    1000 => "M",
    900 => "CM",
    500 => "D",
    400 => "CD",
    100 => "C",
    90 => "XC",
    50 => "L",
    40 => "XL",
    10 => "X",
    9 => "IX",
    5 => "V",
    4 => "IV",
    1 => "I"
  }
  def to_roman
    roman_numeral = ""
    number = self
    NUMBER_TO_ROMAN_MAPPING.each_pair do |digit, roman|
      while number >= digit
        number = number - digit
        roman_numeral << roman
      end
    end
    roman_numeral
  end
end
