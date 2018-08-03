class ConveyorSystem
  attr_accessor :node1, :node2, :travel_time, :link_to, :link_to_right

  def initialize node1:, node2:, travel_time:
    @node1 = node1
    @node2 = node2
    @travel_time = travel_time
  end

end