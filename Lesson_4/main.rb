require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'carriage.rb'
require_relative 'cargo_carriage.rb'
require_relative 'passenger_carriage.rb'

class Railway
  attr_reader :stations, :routes, :trains
  def initialize
    @stations, @routes, @trains = [], [], []
  end

  def choose_option
    opts = ["make_a_station", 
      "make_a_route",
      "add_a_middle_station_to_a_route",
      "remove_a_middle_station_from_a_route",
      "make_a_train",
      "assign_a_route_to_a_train",
      "add_a_carriage_to_a_train",
      "remove_a_carriage_from_a_train", 
      "move_a_train_forward", 
      "move_a_train_back",
      "get_list_of_stations", 
      "get_list_of_trains_placed_in_station"]

    i = choose(opts, "Would you like to")
    self.send(opts[i])
  end
  
  protected

  def make_a_station
    puts "Input the station name"
    name = gets.chomp.capitalize
    make_or_choose_station(name, "The station #{name} already exists")
  end

  def make_a_route
    puts "Input the departure station of the route"
    from_name = gets.chomp.capitalize
    from = make_or_choose_station(from_name)

    puts "Input the destination station of the route"
    to_name = gets.chomp.capitalize
    to = make_or_choose_station(to_name)

    self.routes << Route.new(from, to)
  end

  def add_a_middle_station_to_a_route
    return puts "No routes" if routes.empty?
    route = choose_route
    puts "Input a middle station to add"
    middle_name = gets.chomp.capitalize
    middle = make_or_choose_station(middle_name)
    route.add_middle_station(middle)
  end

  def remove_a_middle_station_from_a_route
    return puts "No routes" if routes.empty?
    route = choose_route
    if route.stations.count > 2
      puts "Choose a station to remove from the route"
      route.stations[1..-2].each.with_index(1) {|v, i| puts "#{i} : #{v.name}"}
      print "> "
      i = gets.chomp.to_i
      station_to_remove = route.stations[i]
      route.remove_middle_station(station_to_remove)
    else
      puts "There is no middle station to remove"
    end   
  end

  def make_a_train
    puts "Input ID of train"
    name = gets.chomp

    i = choose(["passenger", "cargo"], "Choose type of train")
    self.trains << (i == 0 ? PassengerTrain.new(name) : CargoTrain.new(name))
  end

  def assign_a_route_to_a_train
    return puts "No trains to assign a route" if trains.empty?
    train = choose_train
    return puts "No routes to assign to the train" if routes.empty?
    route = choose_route
    train.set_route(route)
  end

  def add_a_carriage_to_a_train
    return puts "No trains to add a carriage" if trains.empty?
    train = choose_train
    carrriage = (train.type == :passenger ? PassengerCarriage.new : CargoCarriage.new)
    train.add_car(carriage)
  end

  def remove_a_carriage_from_a_train
    return puts "No trains to remove a carriage" if trains.empty?
    choose_train.remove_car
  end

  def move_a_train_forward
    return puts "No trains_to_choose" if trains.empty?
    train = choose_train
    train.route.nil? ? (puts "The train has no route ") : train.move_forward
  end

  def move_a_train_back
    return puts "No trains_to_choose" if trains.empty?
    train = choose_train
    train.route.nil? ? (puts "The train has no route ") : train.move_back
  end

  def get_list_of_stations
    return puts "No stations_to_choose" if stations.empty?
    stations.map(&:name).each{|v| puts "#{v}"}
  end

  def get_list_of_trains_placed_in_station
    return puts "No stations_to_choose" if stations.empty?
    i = choose(stations.map(&:name), "Choose a station")
    stations[i].trains.each {|v| puts "#id: #{v.id} type: #{v.type}"}
  end

  def choose(arr, message, index = true)
    puts message
    arr.each.with_index {|v, i| puts "#{i} : #{v}"}
    print "> "
    s = gets.chomp
    i = s.to_i
    if s.to_i.to_s == s && (0...arr.count).include?(i)
      index ? s.to_i : arr[s.to_i]
    else
      puts "Please repeat your choice"
      choose(arr, message, index)
    end
  end

  def make_or_choose_station(name, message = "")
    if station_exist?(name)
      puts message
      stations.select{|v| v.name == name}.first
    else
      station = Station.new(name)
      self.stations << station
      station
    end
  end

  def station_exist? (name)
    stations.map(&:name).include?(name)
  end

  def choose_train
    puts "Choose a train"
    trains.each.with_index {|v, i| puts "#{i} : id: #{v.id} type: #{v.type}"}
    print "> "
    s = gets.chomp
    i = s.to_i
    if s.to_i.to_s == s && (0...trains.count).include?(i)
      trains[i]
    else
      puts "Please repeat your choice"
      choose_train
    end
  end

  def choose_route
    puts "Choose a route"
    routes.each.with_index {|v, i| puts "#{i} : #{v.stations.values_at(0, -1).map(&:name)}"}
    print "> "
    s = gets.chomp
    i = s.to_i
    if s.to_i.to_s == s && (0...routes.count).include?(i)
        routes[i]
    else
      puts "Please repeat your choice"
      choose_route
    end
  end
end
