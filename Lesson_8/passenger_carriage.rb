# frozen_string_literal: true

class PassengerCarriage < Carriage
  attr_reader :type, :vacant_seats, :total_seats

  def initialize(total_seats)
    super()
    @type = :passenger
    @total_seats = total_seats
    @vacant_seats = total_seats
  end

  def occupy_a_seat
    self.vacant_seats -= 1
  end

  def busy_seats
    total_seats - vacant_seats
  end

  protected

  attr_writer :vacant_seats
end
