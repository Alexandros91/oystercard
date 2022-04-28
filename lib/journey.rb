class Journey

  PENALTY_FARE = 6

  def initialize(station)
    @entry_station = station
  end 

  def complete?
    
  end

  def finish(station)
    Journey.new(station: station)
  end

  def fare
    PENALTY_FARE
  end
end