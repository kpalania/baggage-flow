require_relative 'models/conveyor_system'
require_relative 'models/departure'
require_relative 'models/bag'
require_relative 'models/optimized_route'
require_relative 'lib/util'
require_relative 'lib/tree'
require_relative 'lib/route'

include Tree
include Route
include Util

PATH_TO_INPUT_FILE = '/Users/development/Downloads/input.txt'

# Read data from models file.
conveyors_data, departures_data, bags_data = get_file_sections PATH_TO_INPUT_FILE
puts "\nDEBUG STATEMENTS\n----------------\nconveyors: #{conveyors_data}"
puts "departures: #{departures_data}"
puts "bags: #{bags_data}"

# Create respective objects.
conveyors = create_conveyors conveyors_data
departures = create_departures departures_data
bags = create_bags bags_data

# Generate the conveyor system tree.
generate_tree conveyors
puts "\nconveyor system tree: #{conveyors}"

# Calculate optimal routes.
optimized_routes = compute_optimal_routes conveyors, departures, bags

# Display optimized routes.
display_optimized_routes optimized_routes


