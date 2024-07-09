require_relative 'modules.rb'
require_relative 'valid.rb'

require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'carriage.rb'
require_relative 'cargo_carriage.rb'
require_relative 'passenger_carriage.rb'



class Railway
  include Valid
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
      "get_list_of_trains_placed_in_station",
      "exit_menu"]

    i = choose(opts, "option")
    (self.send(opts[i]); choose_option) if opts.count != i + 1
  end
  
  protected

  def make_a_station
      puts "Input the station name"
      name = gets.chomp.capitalize
      make_or_choose_station(name, "The station #{name} already exists")
      rescue => e
      puts "#{e.message}"
    #retry if not valid? Station.new(name)
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
    route = choose(routes, "route", false)
    puts "Input a middle station to add"
    middle_name = gets.chomp.capitalize
    middle = make_or_choose_station(middle_name)
    route.add_middle_station(middle)
  end

  def remove_a_middle_station_from_a_route
    return puts "No routes" if routes.empty?
    route = choose(routes, "route", false)
    if route.stations.count > 2
      i = choose(route.stations[1..-2], "middle station")
      station_to_remove = route.stations[i + 1]
      route.remove_middle_station(station_to_remove)
    else
      puts "There is no middle station to remove"
    end   
  end
  
  def make_a_train
    puts "Input ID of train"
    id = gets.chomp
    (puts "Correct the train's ID according to the specification"; id = gets.chomp) if not valid? id
    i = choose(["passenger", "cargo"], "type of train")
    self.trains << (i == 0 ? PassengerTrain.new(id) : CargoTrain.new(id))
    puts "The train is created"
  end

  def assign_a_route_to_a_train
    return puts "No trains to assign a route" if trains.empty?
    train = choose(trains, "train", false)
    return puts "No routes to assign to the train" if routes.empty?
    route = choose(routes, "route", false)
    train.set_route(route)
  end

  def add_a_carriage_to_a_train
    return puts "No trains to add a carriage" if trains.empty?
    train = choose(trains, "train", false)
    carriage = (train.type == :passenger ? PassengerCarriage.new : CargoCarriage.new)
    return puts "The train should be stopped to add a carriage" if train.speed != 0
    train.add_car(carriage)
  end
  
  def remove_a_carriage_from_a_train
    return puts "No trains to remove a carriage" if trains.empty?
    train = choose(trains, "train", false)
    case
    when train.speed != 0
      return puts "The train should be stopped to remove a carriage"
    when train.carriages.empty?
      return puts "No carriages to remove"
    else
      train.remove_car
    end
  end

  def move_a_train_forward
    return puts "No trains_to_choose" if trains.empty?
    train = choose(trains, "train", false)
    train.route.nil? ? (puts "The train has no route ") : train.move_forward
  end

  def move_a_train_back
    return puts "No trains_to_choose" if trains.empty?
    train = choose(trains, "train", false)
    train.route.nil? ? (puts "The train has no route ") : train.move_back
  end

  def get_list_of_stations
    return puts "No stations_to_choose" if stations.empty?
    stations.map(&:name).each{|v| puts "#{v}"}
  end

  def get_list_of_trains_placed_in_station
    return puts "No stations_to_choose" if stations.empty?
    i = choose(stations.map(&:name), "station")
    stations[i].trains.each {|v| puts "#id: #{v.id} type: #{v.type}"}
  end

  def choose(arr, data, index = true)
    puts "Choose a(n) #{data}"
    case data
    when "option", "station", "type of train"
      arr.each.with_index {|v, i| puts "#{i} : #{v}"}
    when "route" 
      arr.each.with_index {|v, i| puts "#{i} : #{v.stations.values_at(0, -1).map(&:name)}"}
    when "train" 
      arr.each.with_index {|v, i| puts "#{i} : id: #{v.id} type: #{v.type}"}
    when "middle station"
      arr.each.with_index {|v, i| puts "#{i} : #{v.name}"}
    end
    print "> "
    s = gets.chomp
    i = s.to_i
    if s.to_i.to_s == s && (0...arr.count).include?(i)
      index ? s.to_i : arr[s.to_i]
    else
      puts "Please repeat your choice"
      choose(arr, data, index)
    end
  end

  def make_or_choose_station(name, message = "")
    if stations.map(&:name).include?(name)
      puts message
      stations.select{|v| v.name == name}.first
    else
      station = Station.new(name)
      self.stations << station
      station
    end
  end
end
