class Departure
  attr_accessor :flight_id, :flight_gate, :destination, :flight_time

  def initialize flight_id:, flight_gate:, destination:, flight_time:
    @flight_id = flight_id
    @flight_gate = flight_gate
    @destination = destination
    @flight_time = flight_time
  end

end