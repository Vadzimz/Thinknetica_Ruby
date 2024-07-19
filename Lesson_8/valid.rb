# frozen_string_literal: true

module Valid
  ID_TRAIN_PATTERN = /[\w\d]{3}-?[\w\d]{2}/.freeze

  def validate!
    train_id_warning = "The train's ID is out of specification"
    case self
    when Station
      raise 'The station name should have more symbols ' if name.length < 2
      raise 'White space after first symbol is not allowed' if name =~ /^[\w\d]\s/
    when Train
      raise train_id_warning unless id.match? ID_TRAIN_PATTERN
    end
  end

  def validate_choosing(input:, arr:)
    raise 'Your input is out of variants to choose' if input.to_i.to_s != input || !(0...arr.count).include?(input.to_i)
  end

  def valid?
    validate!
  rescue StandardError
    false
  end
end
