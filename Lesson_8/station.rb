# frozen_string_literal: true

class Station
  include InstanceCounter
  include Valid
  attr_reader :name, :trains

  @@stations = []

  class << self
    def all
      @@stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
    validate!
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def do_with_trains(&block)
    trains.each_with_index(&block)
  end

  def show_trains_detailed
    trains.group_by(&:type).transform_values(&:count).each { |k, v| puts "#{k}: #{v} train(s)" }
  end
end
