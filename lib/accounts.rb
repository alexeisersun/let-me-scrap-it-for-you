# frozen_string_literal: true

# Container for multiple accounts.
# Under the hood it uses Array for storing accounts.
#
class Accounts
  attr_reader :accounts

  def initialize
    @accounts = []
  end

  def <<(value)
    @accounts << value
  end

  def [](key)
    @accounts.find { |a| a.name == key }
  end

  def to_hash
    { accounts: @accounts.map { |e| e.to_hash } }
  end

  def to_s
    @accounts.reduce("Accounts:\n") { |mem, a| mem + a.to_s + "\n" }
  end
end
