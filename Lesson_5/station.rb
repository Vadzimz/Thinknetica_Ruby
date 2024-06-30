class Station
  include InstanceCounter
  attr_reader :name, :trains
  @@stations = []

  class << self
    def all
      @@stations
    end
  end
  
  def initialize(name)
    @name, @trains = name, []
    @@stations << self
    register_instance
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
