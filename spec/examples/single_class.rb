class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel=nil)
    @chainring  = chainring
    @cog        = cog
    @wheel      = wheel

    bob = Bob::DontUse.new
  end
end
