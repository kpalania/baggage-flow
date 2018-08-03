module Tree

  #
  # Generates the conveyor system tree.
  #
  def generate_tree conveyors
    conveyors.each {|conveyor|
      found = conveyors.select {|cs| conveyor.node1 == cs.node2}.first
      found2 = conveyors.select {|cs| cs.node2 == conveyor.node2}
      found.link_to = found2 if found
    }
  end

end