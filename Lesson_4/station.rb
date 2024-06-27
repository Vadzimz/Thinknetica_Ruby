class Station
      attr_reader :name, :trains
    
      def initialize(name)
        @name, @trains = name, []
      end
    
      def accept_train(train)
        @trains << train
      end
    
      def send_train(train)
        trains.delete(train)
      end
    
      def show_trains
        trains.each {|tr| puts "#{tr.id}"}
      end
    
      def show_trains_detailed
        trains.group_by{|tr| tr.type}.transform_values{|v| v.count}.each{|k, v| puts "#{k}: #{v} train(s)"}
      end
end
