# frozen_string_literal: true

# Container for multiple transactions.
# Under the hood it uses Array for storing accounts.
#
class Transactions
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def <<(value)
    @transactions << value
  end

  def to_hash
    { transactions: @transactions }
  end

  def to_s
    @transactions.reduce("Transactions:\n") { |mem, t| mem + t.to_s + "\n" }
  end
end
