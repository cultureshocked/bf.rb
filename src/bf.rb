def interpreter(code)
  cell_ptr = 0
  code_ptr = 0
  call_stack = []
  cells = [0]
  # negative_offset = 0

  until code_ptr == code.size do
    sleep 0.1
    p "code_ptr: #{code_ptr}; cell_ptr: #{cell_ptr}"
    p cells
    case code[code_ptr]
    when '.'
      print cells[cell_ptr].chr
      code_ptr += 1
    when '+'
      cells[cell_ptr] += 1
      code_ptr += 1;
    when "-"
      cells[cell_ptr] -= 1
      code_ptr += 1
    when "["
      code_ptr += 1
      call_stack << code_ptr
    when "]"
      if cells[cell_ptr] == 0
        return "ERR: INVALID RETURN ADDRESS (Mismatched ']') @ #{code_ptr}" unless call_stack.pop
        code_ptr += 1
        next
      else
        code_ptr = call_stack[-1]
      end
    when ">"
      cell_ptr += 1
      cells << 0 if cells[cell_ptr].nil?
      code_ptr += 1
    when "<"
      return "ERR: NEGATIVE CELL @ #{code_ptr}" if cell_ptr == 0
      cell_ptr -= 1
      code_ptr += 1
    else
      return "ERR: INVALID SYMBOL '#{code[code_ptr]}' @ #{code_ptr}"
    end
  end
  return "PROGRAM END"
end

if ARGV.size != 1
  puts "usage: ruby bf.rb [SOURCE FILE]"
  exit
end

code = File.open(ARGV[0], "r").readlines.map(&:strip).join("");
# p code

p interpreter(code)
