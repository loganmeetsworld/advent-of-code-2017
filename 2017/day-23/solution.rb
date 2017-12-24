require 'pry'

class String
  def is_i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end
end

registers = File.open('input.txt').read.lines

def run(registers)
  current_position, values, count = 0, Hash.new(0), 0

  while current_position >= 0 && current_position <= registers.length
    line = registers[current_position]
    i, x, y = line.split[0], line.split[1], line.split[2]
    y = values[y] if !y.is_i? if y; y = y.to_i
    case i
    when 'set'
      values[x] = y
    when 'sub'
      values[x] -= y
    when 'mul'
      values[x] *= y
      count += 1
    when 'jnz'
      n = x.is_i? ? x.to_i : values[x]
      current_position = (current_position + y) % registers.length - 1 if n != 0
    end
    current_position += 1
    puts current_position
  end

  return count
end

puts "Part 1: #{run(registers)}"
