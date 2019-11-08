class PhoneNumber

  @@numerals = [
    '0','1','2','3','4','5','6','6','7','8','9'
  ]

  @@country_code = '1'

  def initialize number
    @digits = number.split ''
    filter_chars!
    strip_country_code!
  end

  def to_s
    number = @digits.join
    [@@country_code, number].join
  end

  def is_valid?
    return @digits.length == 10
  end

  def filter_chars!
    @digits.select! do |digit|
      @@numerals.include? digit
    end
  end

  def strip_country_code!
    @digits.shift if @digits[0] == '1'
  end

end