# frozen_string_literal: true

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

  def initialize(id)
    @id = id
    @speed = 0
    @carriages = []
    validate!
    @@trains << self
    register_instance
  end

  def assign_a_route(route)
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
    carriages << car if speed.zero? && car.type == type
  end

  def remove_car
    carriages.delete_at(-1) if speed.zero? && !carriages.empty?
  end

  def move_forward
    return unless next_st

    (self.st_ind += 1
     prev_st.send_train(self)
     curr_st.accept_train(self))
  end

  def move_back
    return unless prev_st

    (self.st_ind -= 1
     next_st.send_train(self)
     curr_st.accept_train(self))
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

  def do_with_carriages(&block)
    carriages.each_with_index(&block)
  end

  protected

  attr_writer :speed, :st_ind
end
