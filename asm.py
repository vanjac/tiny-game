import binascii
import sys

def error(lineNum, message):
    print("Error on line", lineNum, ":", message)

def make_byte(upper, lower):
    return (upper << 4) + lower;

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
            error(line_num, "Program is too large")
            break
        words = [w.strip().lower() for w in line.strip().split()]
        if len(words) == 0:
            continue
        command = words[0]
        if command == 'nop':
            program += bytes([0])
        elif command == 'iff':
            program += bytes([make_byte(1, int(words[1]))])
        elif command == 'clf':
            program += bytes([make_byte(2, int(words[1]))])
        elif command == 'tog':
            program += bytes([make_byte(3, int(words[1]))])
        elif command == 'inc':
            program += bytes([make_byte(4, int(words[1]))])
        elif command == 'dec':
            program += bytes([make_byte(5, int(words[1]))])
        elif command == 'set':
            program += bytes([make_byte(6, int(words[1])),
                              make_byte(0, int(words[2]))])
        elif command == 'spr':
            program += bytes([make_byte(7, int(words[1])),
                              make_byte(int(words[3]), int(words[2]))])
        elif command == 'jmp':
            jumps.append((len(program), words[1], line_num))
            program += bytes([0, 0])
        elif command == 'dpx':
            program += bytes([make_byte(8 + int(words[2]), int(words[1]))])
        elif command == 'rpx':
            program += bytes([make_byte(12 + int(words[2]), int(words[1]))])
        elif command == '.lbl':
            label_indices[words[1]] = len(program) - 1
        elif command == '.align':
            program_len = len(program)
            block_size = int(words[1])
            if program_len % block_size != 0:
                num_filler = block_size - (program_len % block_size)
                program += bytes([0] * num_filler)
        elif command == '.c':
            pass
        else:
            error(line_num, "Unrecognized command")
            break

    for jmp in jumps:
        jump_index = jmp[0]
        if not jmp[1] in label_indices:
            error(jmp[2], "Unrecognized label " + jmp[1])
            continue
        label_index = label_indices[jmp[1]]
        if jump_index // 256 != label_index // 256:
            if jump_index % 16 != label_index % 16:
                error(line_num, "Jump address doesn't match label")
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
