class Oystercard

  attr_reader :balance
  attr_reader :status
  attr_reader :entry_station
  attr_reader :exit_station
  attr_reader :history

  MAXIMUM_CAPACITY = 90
  MINIMUM_AMOUNT = 1
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @status = false
    @entry_station = nil
    @history = []
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

  def touch_out(station)
    fail 'Oyster not touched in' if !in_journey?
    @status = false
    deduct(MINIMUM_FARE)
    @exit_station = station
    @history << {entry_station: @entry_station, exit_station: @exit_station}
    @entry_station = nil
  end

  def in_journey?
    !!entry_station
  end



  private
  def deduct(money)
    @balance -= money
  end
end