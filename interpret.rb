require_relative 'ast'
require_relative 'errors'

class Interpreter
  def initialize(lines)
    @lines = lines
    @symbol_table = Hash.new
    @statement_list = AST::StatementList.new
  end

  def process
    @lines.each do |line|
      parse(line)
    end
  end

  def print
    pp @statement_list
  end

  def parse(line)
    if line.include?("if")
      if_statement = parse_if_statement(line)
      @statement_list.statements << if_statement
    elsif line.include?(" = ") && line.chars.last == ";"
      name, _, value = line.chop.split(" ")

      assignment_expression = parse_assignment(name, value)
      @statement_list.statements << assignment_expression
    end
  end

  private

  def parse_statement(terms)
    case terms.first
    when "print"
      return AST::PrintStatement.new(atom: terms.last)
    end
  end

  def parse_comparison(left, operator, right)
    raise Errors::InvalidInputError unless left.start_with?("(")
    raise Errors::InvalidInputError unless right.end_with?(")")

    case operator
    when "=="
      AST::ComparisonOperators::Equals.new(
        left: left.delete_prefix('('),
        right: right.delete_suffix(')')
      )
    end
  end

  def parse_assignment(name, value)
    @symbol_table[name] = value.to_i
    AST::AssignmentExpression.new(identifier: name, literal: value)
  end

  def parse_if_statement(line)
    terms = line.split(" ")
    if_position = terms.index("if")

    simple_statement_terms = terms.slice(0, if_position)
    simple_statement = parse_statement(simple_statement_terms)

    left, operator, right = terms.drop(if_position + 1)
    comparison = parse_comparison(left, operator, right)

    AST::IfStatement.new(
      comparison: comparison,
      simple_statement: simple_statement
    )
  end
end

ARGV.each do|filename|
  lines = File.readlines(filename).map(&:chomp)
  interpreter = Interpreter.new(lines)

  interpreter.process
  interpreter.print
end
