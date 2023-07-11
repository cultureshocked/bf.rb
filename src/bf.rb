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
      if cells[cell_ptr] == 0
        bracket_stack = [code_ptr]
        code_ptr += 1
        until bracket_stack.size == 0
          if code_ptr == code.size
            puts "ERR: MISMATCHED LOOP BRACKETS FROM #{bracket_stack[0]}"
            return
          end

          case code[code_ptr]
          when '['
            bracket_stack << code_ptr
          when ']'
            bracket_stack.pop
          else

          end
          code_ptr += 1
        end
        next
      end
      call_stack << code_ptr
      code_ptr += 1
    when "]"
      code_ptr = call_stack.pop
      if code_ptr.nil?
        puts "ERR: INVALID RETURN ADDRESS (Mismatched ']') @ #{code_ptr}"
        return
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
    when ' '
      code_ptr += 1
      next
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

interpreter(code)
