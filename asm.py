import binascii
import sys

def error(message):
    global line_num
    print("Error on line", line_num, ":", message)

def make_byte(upper, lower):
    return (upper << 4) + lower

def parse_bounded(word, max_val):
    try:
        n = int(word)
        if n < 0 or n >= max_val:
            error("Value out of range")
            return 0
        return n
    except:
        error("Not a number")
        return 0

def parse_nibble(word):
    return parse_bounded(word, 16)

def parse_color(word):
    return parse_bounded(word, 4)

def parse_register(word):
    if not word.startswith('r'):
        error("Invalid register")
        return 0
    return parse_nibble(word[1:])

def parse_flag(word):
    if not word.startswith('f'):
        error("Invalid flag")
        return 0
    return parse_nibble(word[1:])

if __name__ == "__main__":
    asm_file_name = sys.argv[1]
    asm_file = open(asm_file_name, 'rt')
    lines = asm_file.readlines()
    asm_file.close()

    out_file_name = sys.argv[2]
    out_file = open(out_file_name, 'wb')

    program = bytearray()
    label_indices = { }
    jumps = [ ] # (index, name, line num)

    line_num = 0
    for line in lines:
        line_num += 1
        if len(program) > 4096:
            error("Program is too large")
            break
        words = [w.strip().lower() for w in line.strip().split()]
        if len(words) == 0:
            continue
        command = words[0]
        if command == 'nop':
            program += bytes([0])
        elif command == 'iff':
            program += bytes([make_byte(1, parse_flag(words[1]))])
        elif command == 'clf':
            program += bytes([make_byte(2, parse_flag(words[1]))])
        elif command == 'tog':
            program += bytes([make_byte(3, parse_flag(words[1]))])
        elif command == 'inc':
            program += bytes([make_byte(4, parse_register(words[1]))])
        elif command == 'dec':
            program += bytes([make_byte(5, parse_register(words[1]))])
        elif command == 'set':
            program += bytes([make_byte(6, parse_register(words[1])),
                              make_byte(0, parse_nibble(words[2]))])
        elif command == 'spr':
            program += bytes([make_byte(7, parse_register(words[1])),
                make_byte(parse_nibble(words[3]), parse_nibble(words[2]))])
        elif command == 'jmp':
            jumps.append((len(program), words[1], line_num))
            program += bytes([0, 0])
        elif command == 'dpx':
            program += bytes([make_byte(8 + parse_color(words[2]),
                                        parse_register(words[1]))])
        elif command == 'rpx':
            program += bytes([make_byte(12 + parse_color(words[2]),
                                        parse_register(words[1]))])
        elif command == '.lbl':
            label_indices[words[1]] = len(program) - 1
        elif command == '.align':
            program_len = len(program)
            block_size = parse_bounded(words[1], 4096)
            if program_len % block_size != 0:
                num_filler = block_size - (program_len % block_size)
                program += bytes([0] * num_filler)
        elif command == '.c':
            pass
        else:
            error("Unrecognized command")
            break

    for jmp in jumps:
        line_num = jmp[2] # for error messages
        jump_index = jmp[0]
        if not jmp[1] in label_indices:
            error("Unrecognized label " + jmp[1])
            continue
        label_index = label_indices[jmp[1]]
        if jump_index // 256 != label_index // 256:
            if jump_index % 16 != label_index % 16:
                error("Jump address doesn't match label")
            label_index //= 16
            program[jump_index] = make_byte(7, 13)
            program[jump_index + 1] = make_byte(label_index % 16, label_index // 16)
        else:
            label_index %= 256
            program[jump_index] = make_byte(7, 14)
            program[jump_index + 1] = make_byte(label_index % 16, label_index // 16)

    out_file.write(program)
    out_file.close()

    print("Wrote to", out_file_name)
