# frozen_string_literal: true

require_relative 'modules'
require_relative 'valid'

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'

class Railway
  include Valid
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  OPTS = %w[make_a_station make_a_route
            add_a_middle_station_to_a_route
            remove_a_middle_station_from_a_route
            make_a_train assign_a_route_to_a_train
            add_a_carriage_to_a_train
            remove_a_carriage_from_a_train
            move_a_train_forward
            move_a_train_back
            obtain_list_of_stations
            obtain_info_on_trains_placed_in_station
            obtain_list_of_carriages_of_a_train
            occupy_a_seat_in_a_passenger_train
            fill_some_volume_in_a_cargo_train
            exit_menu].freeze

  def choose_option
    i = choose(OPTS, 'option', index: true, &DEFAULT_OUTPUT)
    return unless OPTS.count != i + 1

    send(OPTS[i])
    choose_option
  end

  protected

  attr_writer :stations, :routes, :trains

  def make_a_station
    puts 'Input the station name'
    name = gets.chomp.capitalize
    make_or_choose_station(name, "The station #{name} already exists")
  rescue StandardError => e
    puts "#{e.message}. Try again"
    retry
  end

  def make_a_route
    puts 'Input the departure station of the route'
    from_name = gets.chomp.capitalize
    from = make_or_choose_station(from_name)

    puts 'Input the destination station of the route'
    to_name = gets.chomp.capitalize
    to = make_or_choose_station(to_name)

    routes << Route.new(from, to)
  end

  def add_a_middle_station_to_a_route
    return puts 'No routes' if routes.empty?

    route = choose(routes, 'route', &ROUTE_OUTPUT)
    puts 'Input a middle station to add'
    middle_name = gets.chomp.capitalize
    middle = make_or_choose_station(middle_name)
    route.add_middle_station(middle)
  end

  def remove_a_middle_station_from_a_route
    return puts 'No routes' if routes.empty?

    route = choose(routes, 'route', &ROUTE_OUTPUT)
    if route.stations.count > 2
      i = choose(route.stations[1..-2], 'middle station', index: true, &STATION_OUTPUT)
      station_to_remove = route.stations[i + 1]
      route.remove_middle_station(station_to_remove)
    else
      puts 'There is no middle station to remove'
    end
  end

  def make_a_train
    puts 'Input ID of train'
    id = gets.chomp
    i = choose(%w[passenger cargo], 'type of train', index: true, &DEFAULT_OUTPUT)
    trains << (i.zero? ? PassengerTrain.new(id) : CargoTrain.new(id))
    puts 'The train is created'
  rescue StandardError => e
    puts "#{e.message}. Try again"
    retry
  end

  def assign_a_route_to_a_train
    return puts 'No trains to assign a route' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    return puts 'No routes to assign to the train' if routes.empty?

    route = choose(routes, 'route', &ROUTE_OUTPUT)
    train.assign_a_route(route)
  end

  def add_a_carriage_to_a_train
    return puts 'No trains to add a carriage' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    return puts 'The train should be stopped to add a carriage' if train.speed != 0

    case train.type
    when :passenger
      puts 'Input number of seats'
      total_seats = gets.chomp.to_i
      carriage = PassengerCarriage.new(total_seats)
    when :cargo
      puts 'Input full volume of wagon'
      full_volume = gets.chomp.gsub(',', '.').to_f
      carriage = CargoCarriage.new(full_volume)
    end
    train.add_car(carriage)
  end

  def remove_a_carriage_from_a_train
    return puts 'No trains to remove a carriage' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    if train.speed != 0
      puts 'The train should be stopped to remove a carriage'
    elsif train.carriages.empty?
      puts 'No carriages to remove'
    else
      train.remove_car
    end
  end

  def move_a_train_forward
    return puts 'No trains_to_choose' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    train.route.nil? ? (puts 'The train has no route ') : train.move_forward
  end

  def move_a_train_back
    return puts 'No trains_to_choose' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    train.route.nil? ? (puts 'The train has no route ') : train.move_back
  end

  def obtain_list_of_stations
    return puts 'No stations_to_choose' if stations.empty?

    stations.each_with_index(&STATION_OUTPUT)
  end

  def obtain_list_of_carriages_of_a_train
    return puts 'No trains_to_choose' if trains.empty?

    train = choose(trains, 'train', &TRAIN_OUTPUT)
    case train.type
    when :passenger
      train.carriages.each_with_index(&PASSENGER_CAR_OUTPUT)
    when :cargo
      train.carriages.each_with_index(&CARGO_CAR_OUTPUT)
    end
  end

  def obtain_info_on_trains_placed_in_station
    return puts 'No stations_to_choose' if stations.empty?

    station = choose(stations, 'station', &STATION_OUTPUT)

    return puts 'No trains_to_choose' if station.trains.empty?

    train = choose(station.trains, 'train', &TRAIN_OUTPUT)
    case train.type
    when :passenger
      train.carriages.each_with_index(&PASSENGER_CAR_OUTPUT)
    when :cargo
      train.carriages.each_with_index(&CARGO_CAR_OUTPUT)
    end
  end

  def occupy_a_seat_in_a_passenger_train
    p_trains = trains.select { |tr| tr.type == :passenger }
    return puts 'No trains_to_choose' if p_trains.empty?

    train = choose(p_trains, 'train', &TRAIN_OUTPUT)
    return puts 'No carriages to choose' if train.carriages.empty?

    available_carriages = train.carriages.select { |car| car.vacant_seats.positive? }
    return puts 'No available seats' if available_carriages.empty?

    car = choose(available_carriages, 'carriage', &PASSENGER_CAR_OUTPUT)
    car.occupy_a_seat
    puts 'The seat is booked'
  end

  def fill_some_volume_in_a_cargo_train
    c_trains = trains.select { |tr| tr.type == :cargo }
    return puts 'No trains_to_choose' if c_trains.empty?

    train = choose(c_trains, 'train', &TRAIN_OUTPUT)
    return puts 'No carriages to choose' if train.carriages.empty?

    available_carriages = train.carriages.select { |car| car.free_volume.positive? }
    return puts 'No free volume' if available_carriages.empty?

    car = choose(available_carriages, 'carriage', &CARGO_CAR_OUTPUT)
    puts 'Input volume to fill'
    volume = gets.chomp.gsub(',', '.').to_f
    if volume > car.free_volume
      print 'Confirm to fill all available volume of the carriage(y/n)'
      gets.chomp == 'y' ? car.fill_volume(car.free_volume) : (return puts 'Not enough free volume')
    else
      car.fill_volume(volume)
    end
    puts 'The volume is filled'
  end

  DEFAULT_OUTPUT = proc { |v, i| puts "#{i} : #{v}" }
  ROUTE_OUTPUT = proc { |v, i|
    puts "#{i} : departure station: #{v.stations.first.name}  -  destination station: #{v.stations.last.name}"
  }
  STATION_OUTPUT = proc { |v, i| puts "#{i} : #{v.name}, #{v.trains.size} trains" }
  TRAIN_OUTPUT = proc { |v, i|
    puts "#{i}: train id: #{v.id}, type: #{v.type}, quantity of carriages: #{v.carriages.size}"
  }
  PASSENGER_CAR_OUTPUT =
    proc { |v, i|
      puts "carriage_number: #{i}, type: #{v.type}, vacant_seats: #{v.vacant_seats}, busy_seats: #{v.busy_seats}"
    }
  CARGO_CAR_OUTPUT =
    proc { |v, i|
      puts "carriage_number: #{i}, type: #{v.type}, free_volume: #{v.free_volume}, filled_volume: #{v.filled_volume}"
    }

  def choose(arr, data, index: false, &output)
    puts "Choose a(n) #{data}"
    arr.each.with_index(&output)
    print '> '
    s = gets.chomp
    validate_choosing input: s, arr: arr
    index ? s.to_i : arr[s.to_i]
  rescue StandardError => e
    puts "#{e.message}. Try again"
    retry
  end

  def make_or_choose_station(name, message = '')
    if stations.map(&:name).include?(name)
      puts message
      stations.select { |v| v.name == name }.first
    else
      station = Station.new(name)
      stations << station
      station
    end
  end

  def st(name)
    stations.find { |st| st.name == name }
  end

  def tr(id)
    trains.find { |t| t.id == id }
  end

  public

  def seed
    stations = %w[Moscow Minsk Smolensk Borisov St-Petersburg Bologoe Tver Ryazan Voronezh]
    self.stations = stations.map { |st| Station.new(st) }

    p_ids = %w[001-01 002-01 003-01]
    c_ids = %w[001-02 002-02 003-02]
    self.trains = p_ids.map { |t| PassengerTrain.new(t) } + c_ids.map { |t| CargoTrain.new(t) }

    self.routes = [Route.new(st('Moscow'), st('Minsk')),
                   Route.new(st('Moscow'), st('St-Petersburg')),
                   Route.new(st('Moscow'), st('Voronezh'))]

    routes[0].add_middle_station(st('Borisov'))
    routes[0].add_middle_station(st('Smolensk'))
    routes[1].add_middle_station(st('Tver'))
    routes[1].add_middle_station(st('Bologoe'))
    routes[2].add_middle_station(st('Ryazan'))

    tr('001-01').assign_a_route(routes[0])
    tr('002-01').assign_a_route(routes[1])
    tr('003-01').assign_a_route(routes[2])
    tr('001-02').assign_a_route(routes[0])
    tr('002-02').assign_a_route(routes[1])
    tr('003-02').assign_a_route(routes[2])

    10.times { tr('001-01').add_car PassengerCarriage.new(40) }
    20.times { tr('002-01').add_car PassengerCarriage.new(20) }
    15.times { tr('003-01').add_car PassengerCarriage.new(40) }

    50.times { tr('001-02').add_car CargoCarriage.new(50.0) }
    40.times { tr('002-02').add_car CargoCarriage.new(100.0) }
    30.times { tr('003-02').add_car CargoCarriage.new(30.5) }

    puts 'Seed data is created'
  end
end
