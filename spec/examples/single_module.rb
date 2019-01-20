module Circle
  def circumference
    diameter * Math::PI
  end

  def diameter
    rim + (tire * 2)
  end
end
