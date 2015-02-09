class Object
  def is_boolean?
    return self.is_a?(TrueClass) || self.is_a?(FalseClass)
  end

  def to_bool
    if !self.is_boolean?
    	return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    	return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    else
    	return self
	end
    raise ArgumentError.new("invalid value for Object: #{self}")
  end
end