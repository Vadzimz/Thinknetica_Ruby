# frozen_string_literal: true

class CargoCarriage < Carriage
  attr_reader :type, :full_volume, :free_volume
  validate :full_volume, :type, Float

  def initialize(full_volume)
    super()
    @type = :cargo
    @full_volume = full_volume
    @free_volume = full_volume
    validate!
  end

  def fill_volume(volume)
    self.free_volume = full_volume - volume
  end

  def filled_volume
    full_volume - free_volume
  end

  protected

  attr_writer :free_volume
end
