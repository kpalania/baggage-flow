class OptimizedRoute
  attr_accessor :bag_number, :points, :total_travel_time

  def initialize bag_number:, points:, total_travel_time:
    @bag_number = bag_number
    @points = points
    @total_travel_time = total_travel_time
  end

end