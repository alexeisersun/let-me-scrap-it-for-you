class Account
  attr_reader :name, :balance, :currency, :nature

  def initialize(name, balance, currency, nature)
    @name = name
    @balance = balance
    @currency = currency
    @nature = nature
  end

  def to_s
    to_hash.to_s
  end

  def to_hash
    {name: @name, balance: @balance, currency: @currency, nature: @nature}
  end

end
