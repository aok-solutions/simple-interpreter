module AST
  class PrintStatement
    attr_accessor :atom

    def initialize(atom:)
      @atom = atom
    end
  end
end
