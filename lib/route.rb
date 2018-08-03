module Route

  #
  # Computes the optimal routes.
  #
  def compute_optimal_routes conveyors, departures, bags
    optimized_routes = []
    puts "\n"
    bags.each {|bag|
      departure = departures.select {|dep| dep.flight_id == bag.flight_id}.first
      flight_gate = departure ? departure.flight_gate : ARRIVAL
      original_flight_gate = flight_gate
      puts "Compute optimal baggage route from #{bag.entry_point} to #{flight_gate}"

      entry_points = []
      total_travel_time = 0
      common_parent = _common_parent bag.entry_point, conveyors, entry_points, flight_gate, total_travel_time
      _get_optimized_routes bag, common_parent, conveyors, entry_points, flight_gate, optimized_routes,
                            original_flight_gate, total_travel_time
    }

    optimized_routes
  end

  #
  # Displays optimized routes.
  #
  def display_optimized_routes optimized_routes
    puts "\nOUTPUT\n------\n"
    optimized_routes.each {|route|
      puts "#{route.bag_number} #{route.points.join(' ')} : #{route.total_travel_time}"
    }
  end

  #
  # Private.
  #

  private

  # Returns the optimized routes.
  def _get_optimized_routes bag, common_parent, conveyors, entry_points, flight_gate, optimized_routes,
                            original_flight_gate, total_travel_time
    if common_parent
      optimized_route = _create_optimized_route bag, common_parent, bag.entry_point, common_parent.first.uniq.reverse
      optimized_routes << optimized_route
    else
      puts "\n(2) Compute optimal baggage route from #{bag.entry_point} to #{original_flight_gate}"
      common_parent = _common_parent_reverse bag.entry_point, conveyors, entry_points, flight_gate,
                                             original_flight_gate, total_travel_time

      puts "\n(3) Compute optimal baggage route from #{common_parent} to #{bag.entry_point}"
      original_common_parent = common_parent
      entry_points = []
      common_parent = _common_parent common_parent, conveyors, entry_points, bag.entry_point, total_travel_time
      optimized_route0 = _create_optimized_route bag, common_parent, common_parent.first.uniq, original_common_parent
      _optimal_route_in_forward_direction bag, conveyors, optimized_route0, optimized_routes, original_common_parent, original_flight_gate,
                                          total_travel_time
    end
  end

  # Computes the optimal route in the forward direction.
  def _optimal_route_in_forward_direction bag, conveyors, optimized_route0, optimized_routes, original_common_parent,
                                          original_flight_gate, total_travel_time
    if original_common_parent != original_flight_gate
      puts "\n(4) Compute optimal baggage route from #{original_common_parent} to #{original_flight_gate}"
      entry_points = []
      flight_gate = original_flight_gate
      common_parent = _common_parent original_common_parent, conveyors, entry_points, flight_gate, total_travel_time

      optimized_route = _create_optimized_route bag, common_parent, common_parent.first.uniq, nil
      optimized_route0.points += optimized_route.points
      optimized_route0.points = optimized_route0.points.flatten.uniq
      optimized_route0.total_travel_time += optimized_route.total_travel_time
      optimized_routes << optimized_route0
    else
      optimized_routes << optimized_route0
    end
  end

  def _create_optimized_route bag, common_parent, pointsFirstSet, pointsSecondSet
    OptimizedRoute.new bag_number: bag.bag_number, points: [pointsFirstSet, pointsSecondSet].flatten.uniq,
                       total_travel_time: common_parent.last
  end

  def _get_flight_gate conveyors, flight_gate
    conveyors.select {|cs| cs.node2 == flight_gate}.first
  end

  # Abstract the loop from the method that determines the common parent.
  def _common_parent_loop
    loop {yield}
  end

  # Returns the common parent for nodes in the reverse direction.
  def _common_parent_reverse entry_point, conveyors, entry_points, flight_gate, original_flight_gate, total_travel_time
    _common_parent_loop {
      common_parent = _find_common_parent_reverse entry_points, total_travel_time, conveyors, entry_point,
                                                  flight_gate
      return common_parent if common_parent
      flight_gate = _get_flight_gate conveyors, original_flight_gate
      break unless flight_gate
      flight_gate = _get_node1 flight_gate
    }
  end

  # Returns the common parent for nodes in the forward direction.
  def _common_parent entry_point, conveyors, entry_points, flight_gate, total_travel_time
    _common_parent_loop {
      common_parent = _find_common_parent entry_points, total_travel_time, conveyors, entry_point, entry_point,
                                          flight_gate
      return common_parent if common_parent
      flight_gate = _get_flight_gate conveyors, flight_gate
      break unless flight_gate
      flight_gate = _get_node1 flight_gate
    }
  end

  def _get_node1 flight_gate
    flight_gate = flight_gate.node1
    puts "\n..look for parent one level above: #{flight_gate.inspect}"
    flight_gate
  end

  # Finds the common parent when the node request is in the opposite (reverse) direction in the tree.
  def _find_common_parent_reverse entry_points, total_travel_time, conveyors, entry_point, target
    conveyor = conveyors.select {|cs| cs.node2 == entry_point}.first
    if conveyor
      if conveyor.node1 == target
        puts "!!found common parent: #{target}"
        return target
      else
        puts "..keep looking: #{conveyor.node1}, #{target}"
        _find_common_parent_reverse entry_points, total_travel_time, conveyors, conveyor.node1, target
      end
    end
  end

  # Finds the common parent. Need it to find the optimal route later.
  def _find_common_parent entry_points, total_travel_time, conveyors, original_entry_point, entry_point, target
    conveyor = conveyors.select {|cs| cs.node2 == target}.first
    if conveyor
      if conveyor.node1 == entry_point
        puts "!!found common parent: #{entry_point}"
        entry_points << target
        entry_points << conveyor.node1
        total_travel_time += conveyor.travel_time.to_i
        return entry_points, total_travel_time
      elsif conveyor.node1 == original_entry_point
        puts "!!matched source: #{original_entry_point}"
        conveyor = conveyors.select {|cs| cs.node1 == original_entry_point && cs.node2 == target}.first
        total_travel_time += conveyor.travel_time.to_i
        return entry_points, total_travel_time
      else
        puts "..keep looking: #{conveyor.node1}, #{target}"
        entry_points << target
        entry_points << conveyor.node1
        total_travel_time += conveyor.travel_time.to_i
        _find_common_parent entry_points, total_travel_time, conveyors, original_entry_point, target, conveyor.node1
      end
    end
  end

end