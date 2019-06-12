class Transaction
  attr_reader :date, :description, :amount

  def initialize(date, description, amount)
    @date = date
    @description = description
    @amount = amount
  end

  def to_s
    to_hash.to_s
  end

  def to_hash
    {date: @date, description: @description, amount: @amount}
  end
end
