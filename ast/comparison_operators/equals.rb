module AST
  module ComparisonOperators
    class Equals
      attr_accessor :left, :right

      def initialize(left:, right:)
        @left = left
        @right = right
      end
    end
  end
end
