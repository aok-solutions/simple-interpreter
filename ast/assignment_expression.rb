require_relative '../errors/invalid_input_error'

module AST
  class AssignmentExpression
    ASSIGN_OPERATOR = "="

    attr_accessor :identifier, :literal

    def initialize(identifier:, literal:)
      if is_not_integer?(literal)
        raise Errors::InvalidInputError, "#{literal} is not an Integer"
      end

      @identifier = AST::Identifier.new(name: identifier)
      @literal = literal
    end

    private

    def is_not_integer?(literal)
      literal =~ /\D/
    end
  end
end
