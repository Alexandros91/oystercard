class Oystercard

  attr_reader :balance
  attr_reader :status
  
  MAXIMUM_CAPACITY = 90
  MINIMUM_AMOUNT = 1

  def initialize
    @balance = 0
    @status = "not_in_use"
  end

  def top_up(money)
    fail "Maximum balance of #{MAXIMUM_CAPACITY} exceeded" if balance + money > MAXIMUM_CAPACITY
    @balance += money
  end

  def deduct(money)
    @balance -= money
  end

  def touch_in
    fail "Balance is less than £1" if @balance < MINIMUM_AMOUNT
    fail 'Oyster already touched in' if in_journey?
    @status = "in_use"
  end

  def touch_out
    fail 'Oyster not touched in' if !in_journey?
    @status = "not_in_use"
  end

  def in_journey?
    @status == "in_use"
  end
end