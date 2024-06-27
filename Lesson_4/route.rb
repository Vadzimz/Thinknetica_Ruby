class Route
      attr_reader :stations
      def initialize(from, to)
        @stations = [from, to]
      end
    
      def add_middle_station(middle)
        stations.insert(-2, middle) if not stations.include?(middle)
      end
    
      def remove_middle_station(middle)
        stations.delete(middle)
      end
end
