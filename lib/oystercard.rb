class Oystercard

  attr_reader :balance, :history

  MAXIMUM_CAPACITY = 90
  MINIMUM_AMOUNT = 1
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @journey = {}
    @history = []
  end

  def top_up(money)
    check_if_maximum_balance_exceeded(money)
    raise_balance(money)
  end
  
  def touch_in(station)
    check_minimum_balance_for_travel
    check_if_in_journey
    record_entry_station(station)
  end

  def touch_out(station)
    check_if_not_in_journey
    deduct(MINIMUM_FARE)
    record_exit_station(station)
    record_journey
    reset_stations
  end

  def in_journey?
    !!@journey[:entry_station]
  end



  private

  attr_reader :journey

  def deduct(money)
    @balance -= money
  end

  def check_if_maximum_balance_exceeded(money)
    fail "Maximum balance of #{MAXIMUM_CAPACITY} exceeded" if balance + money > MAXIMUM_CAPACITY
  end

  def raise_balance(money)
    @balance += money
  end

  def check_minimum_balance_for_travel
    fail "Balance is less than £1" if @balance < MINIMUM_AMOUNT
  end

  def check_if_in_journey
    fail 'Oyster already touched in' if in_journey?
  end

  def check_if_not_in_journey
    fail 'Oyster not touched in' if !in_journey?
  end

  def record_journey
    @history << @journey
  end

  def reset_stations
    @journey = {}
  end

  def record_entry_station(station)
    @entry_station = station
    @journey[:entry_station] = station
  end

  def record_exit_station(station)
    @journey[:exit_station] = station
  end
end
