module Valid
  ID_TRAIN_PATTERN = /[\w\d]{3}-?[\w\d]{2}/
  
  def validate!
    train_id_warning = "The train's ID is out of specification"
    case self
    when Station
      raise "The station name should have more symbols " if name.length < 2
      raise "White space after first symbol is not allowed" if name =~ /^[\w\d]\s/
    when Train
      raise train_id_warning if not id.match? ID_TRAIN_PATTERN
    end
  end

  def valid?
    validate!
    true
  rescue 
    false
  end
  
end