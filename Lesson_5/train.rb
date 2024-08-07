class Train
  include InstanceCounter
  include Manufacturer
  include Valid

  attr_reader :id, :type, :route, :carriages, :speed, :st_ind

  @@trains = []
  
  class << self
    def find(id)
      @@trains[@@trains.map(&:id).find_index(id)]
    end
  end
      
  def initialize(id, type)
    @id, @type, @speed, @carriages = id, type, 0, []
    validate!
    @@trains << self
    register_instance
  end
      
  def set_route(route)
    @route = route.stations
    @st_ind = 0
    curr_st.accept_train(self)
  end
      
  def stop_train
    self.speed = 0
  end
      
  def accelerate_train(higher_speed)
    self.speed = higher_speed if higher_speed > speed
  end
      
  def add_car(car)
    #speed == 0 && car.type == self.type ? self.carriages << car : (puts "Carriage can't be added")
    self.carriages << car if speed == 0 && car.type == self.type
  end
      
  def remove_car
    #speed == 0 && !carriages.empty? ? self.carriages.delete_at(-1) : (puts "Carriage can't be removed")
    self.carriages.delete_at(-1) if speed == 0 && !carriages.empty?
  end
        
  def move_forward
    (self.st_ind += 1; prev_st.send_train(self); curr_st.accept_train(self)) if next_st
  end
      
  def move_back
    (self.st_ind -= 1; next_st.send_train(self); curr_st.accept_train(self)) if  prev_st
  end
      
  def curr_st
    route[st_ind]
  end
      
  def next_st
    route[st_ind + 1]
  end
      
  def prev_st
    route[st_ind - 1] if st_ind != 0
  end
      
  protected    
  attr_writer :speed, :st_ind
end
