def interpreter(code, debug=false)
  puts "PROGRAM START"
  cell_ptr = 0
  code_ptr = 0
  call_stack = []
  cells = [0]
  # negative_offset = 0

  until code_ptr == code.size do
    sleep 0.1 if debug
    p "code_ptr: #{code_ptr}; cell_ptr: #{cell_ptr}" if debug
    p cells if debug
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
        unless call_stack.pop
          puts "ERR: INVALID RETURN ADDRESS (Mismatched ']') @ #{code_ptr}"
          return
        end
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
      if cell_ptr == 0
        puts "ERR: NEGATIVE CELL @ #{code_ptr}" if cell_ptr == 0
        return
      end
      cell_ptr -= 1
      code_ptr += 1
    else
      puts "ERR: INVALID SYMBOL '#{code[code_ptr]}' @ #{code_ptr}"
      return
    end
  end
  puts "PROGRAM END"
end

if ARGV.size != 1
  puts "usage: ruby bf.rb [SOURCE FILE]"
  exit
end

code = File.open(ARGV[0], "r").readlines.map(&:strip).join("");
# p code

puts interpreter(code)
