# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(id)
    super
    @type = :passenger
  end
end
