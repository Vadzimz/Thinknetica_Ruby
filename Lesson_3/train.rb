class Train
  attr_reader :id
  attr_reader :type
  attr_reader :car_num
  attr_accessor :speed

  attr_reader :curr_st
  attr_reader :prev_st
  attr_reader :next_st

  def initialize(id, type, car_num)
    @id, @type, @car_num, @speed = id, type, car_num, 0
  end

  def set_route(route)
    @@route = route.stations.unshift(nil).push(nil)
    @@st_ind = 1
    @prev_st, @curr_st, @next_st = @@route[@@st_ind - 1, 3]
    puts "The route #{route} is added"
  end

  def add_car
    @speed == 0 ? @car_num += 1 : (puts "Adding a carriage is imposible")
  end

  def remove_car
    @speed == 0 && @car_num > 1 ? @car_num -= 1 : (puts "Removing a carriage is imposible")
  end
    
  def move_forward
    @next_station.nil? ? (puts "The train can't be moved forward") : (@@st_ind += 1; @prev_st, @curr_st, @next_st = @@route[@@st_ind - 1, 3])
  end

  def move_back
    @previous_station.nil? ? (puts "The train can't be moved back") : (@@st_ind -= 1; @prev_st, @curr_st, @next_st = @@route[@@st_ind - 1, 3])
  end
end
