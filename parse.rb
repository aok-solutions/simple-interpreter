class InvalidSyntaxException < StandardError
end

class InvalidCommandException < StandardError
end

COMMANDS = ["print"]
CONJUNCTIONS = ["if"]
OPERATORS = ["=="]

class Interpreter
  def initialize(lines)
    @lines = lines
    @variable_map = Hash.new
  end

  def process
    @lines.each do |line|
      parse(line)
    end
  end

  def parse(line)
    if line.chars.last == ";"
      name, operator, value = line.chop.split(" ")
      parse_assignment(name, operator, value)
    else
      parse_conditional_command(line)
    end
  end

  def parse_assignment(name, operator, value)
    raise InvalidSyntaxException unless operator == "="
    raise InvalidSyntaxException unless alpha?(name)
    raise InvalidSyntaxException unless numeric?(value)

    @variable_map[name] = value.to_i
  end

  def parse_conditional_command(line)
    command, argument, conjunction, left, operator, right = line.split(" ")
    raise InvalidCommandException unless COMMANDS.include?(command)
    raise InvalidCommandException unless CONJUNCTIONS.include?(conjunction)
    raise InvalidCommandException unless OPERATORS.include?(operator)

    raise InvalidCommandException unless argument.is_a? String
    raise InvalidSyntaxException unless left.start_with?("(")
    raise InvalidSyntaxException unless right.end_with?(")")

    case conjunction
    when "if"
      case operator
      when "=="
        condition = @variable_map[left[1..-1]] == @variable_map[right.chop]
        execute_command(command, argument) if condition
      end
    end
  end

  def execute_command(command, argument)
    case command
    when "print"
      pp argument.undump
    end
  end

  def to_string
    @lines.each do |line|
      pp line
    end
  end

  private

  def numeric?(token)
    token =~ /[0-9]/
  end

  def alpha?(token)
    token =~ /[A-Za-z]/
  end
end

ARGV.each do|filename|
  lines = File.readlines(filename).map(&:chomp)
  Interpreter.new(lines).process
end
