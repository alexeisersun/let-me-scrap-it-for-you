class Accounts
  attr_reader :accounts
  
  def initialize
    @accounts = []
  end

  def <<(value)
    @accounts << value
  end

  def [](key)
    @accounts.find {|a| a.name == key }
  end

  def to_hash
    {accounts: @accounts}
  end

  def to_s
      @accounts.reduce("Accounts:\n") { |mem, a|
        mem + a.to_s + "\n"
      }
  end
end
