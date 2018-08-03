class Bag
  attr_accessor :bag_number, :entry_point, :flight_id

  def initialize bag_number:, entry_point:, flight_id:
    @bag_number = bag_number
    @entry_point = entry_point
    @flight_id = flight_id
  end

end