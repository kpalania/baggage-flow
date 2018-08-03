SECTION_CONVEYOR_SYSTEM = '# Section: Conveyor System'
SECTION_DEPARTURES = '# Section: Departures'
SECTION_BAGS = '# Section: Bags'
ARRIVAL = 'BaggageClaim'

module Util
  #
  # Read data from file, and return the various sections.
  #
  def get_file_sections input_file_path
    conveyors, departures, bags = [], [], []
    conveyor, departure, bag = false

    File.open(input_file_path).each do |line|
      if line.strip == SECTION_CONVEYOR_SYSTEM
        conveyor = true
        departure, bag = false, false
      elsif line.strip == SECTION_DEPARTURES
        departure = true
        conveyor, bag = false, false
      elsif line.strip == SECTION_BAGS
        bag = true
        conveyor, departure = false, false
      end

      conveyors << line.chomp if conveyor
      departures << line.chomp if departure
      bags << line.chomp if bag
    end

    conveyors = conveyors.drop(1)
    departures = departures.drop(1)
    bags = bags.drop(1)

    return conveyors, departures, bags
  end

#
# Creates conveyors.
#
  def create_conveyors conveyors
    conveyor_objects = []
    conveyors.each {|conveyor|
      node1, node2, travel_time = conveyor.split
      conveyor_obj = ConveyorSystem.new node1: node1, node2: node2, travel_time: travel_time
      conveyor_objects << conveyor_obj
    }
    conveyor_objects
  end

#
# Creates departures.
#
  def create_departures departures
    departure_objects = []
    departures.each {|departure|
      flight_id, flight_gate, destination, flight_time = departure.split
      departure_obj = Departure.new flight_id: flight_id, flight_gate: flight_gate, destination: destination,
                                    flight_time: flight_time
      departure_objects << departure_obj
    }
    departure_objects
  end

#
# Creates bags.
#
  def create_bags bags
    bag_objects = []
    bags.each {|bag|
      bag_number, entry_point, flight_id = bag.split
      bag_obj = Bag.new bag_number: bag_number, entry_point: entry_point, flight_id: flight_id
      bag_objects << bag_obj
    }
    bag_objects
  end
end