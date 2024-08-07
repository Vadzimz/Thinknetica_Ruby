# frozen_string_literal: true

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
    register_instance
  end

  def add_middle_station(middle)
    stations.insert(-2, middle) unless stations.include?(middle)
  end

  def remove_middle_station(middle)
    stations.delete(middle)
  end
end
