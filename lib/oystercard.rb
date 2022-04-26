class Oystercard

  attr_reader :balance
  attr_reader :status
  attr_reader :entry_station
  
  MAXIMUM_CAPACITY = 90
  MINIMUM_AMOUNT = 1

  def initialize
    @balance = 0
    @status = false
    @entry_station = nil
  end

  def top_up(money)
    fail "Maximum balance of #{MAXIMUM_CAPACITY} exceeded" if balance + money > MAXIMUM_CAPACITY
    @balance += money
  end
  
  def touch_in(station)
    fail "Balance is less than £1" if @balance < MINIMUM_AMOUNT
    fail 'Oyster already touched in' if in_journey?
    @status = true
    @entry_station = station
  end

  def touch_out
    fail 'Oyster not touched in' if !in_journey?
    @entry_station = nil
    @status = false
    deduct(MINIMUM_AMOUNT)
  end

  def in_journey?
    !!entry_station
  end

  private
  def deduct(money)
    @balance -= money
  end
end