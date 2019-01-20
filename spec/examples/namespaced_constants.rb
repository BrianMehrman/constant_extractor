module Space
  module ModuleA
    def foo
      'foo'
    end
  end

  module ModuleB
    def bar
      'bar'
    end
  end

  module ModuleC
    include ModuleA
    def bat
      'bat'
    end
  end


  class RootClass
    def somthing
    end
  end

  class BaseTest < RootClass
    include ModuleB

    def thing
      'root'
    end
  end

  class Test < BaseTest
    include ModuleC
    include ModuleA

    def thing
      'thing'
    end
  end
end
