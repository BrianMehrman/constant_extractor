module GearRatio
  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

  module Foo
    def a
      "rar"
    end
  end
end

class Gear
  include GearRatio

  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel=nil)
    @chainring  = chainring
    @cog        = cog
    @wheel      = wheel
  end
end
