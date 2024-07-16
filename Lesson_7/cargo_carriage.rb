class CargoCarriage < Carriage
  attr_reader :type, :full_volume, :free_volume
  
  def initialize(full_volume)
    super()
    @type = :cargo
    @full_volume = full_volume
    @free_volume = full_volume
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