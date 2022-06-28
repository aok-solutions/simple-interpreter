module AST
  class IfStatement
    attr_accessor :comparison, :simple_statement

    def initialize(comparison:, simple_statement:)
      @comparison = comparison
      @simple_statement = simple_statement
    end
  end
end
