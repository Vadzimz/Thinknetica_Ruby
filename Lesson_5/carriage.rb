class Carriage
  include Manufacturer
  attr_reader :type
  def initialize
    @type = nil
  end
end
