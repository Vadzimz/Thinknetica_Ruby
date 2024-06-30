class CargoTrain < Train
  def initialize(id, type = :cargo)
    super(id, type)
  end
end
