require_relative '../errors/invalid_input_error'

module AST
  class Identifier
    attr_accessor :name

    def initialize(name:)
      if is_not_alpha?(name)
        raise Errors::InvalidInputError, "#{name} is not a letter in the alphabet"
      end

      @name = name
    end

    private

    def is_not_alpha?(token)
      token =~ /[^A-Za-z]/
    end
  end
end
