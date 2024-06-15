class Route
  attr_reader :stations
  def initialize(from, to)
    @stations = [from, to]
  end

  def add_middle_station(middle)
    @stations.include?(middle) ? (puts "This is already in the route") : @stations.insert(-2, middle)
  end

  def remove_middle_station(middle)
    @stations.values_at(1, -1).include?(middle) ? (puts "This station can't be deleted") : @stations.delete(middle)
  end
end
