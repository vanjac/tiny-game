import binascii
import sys

def error(lineNum, message):
    print("Error on line", lineNum, ":", message)

if __name__ == "__main__":
    
    asmFileName = sys.argv[1]
    asmFile = open(asmFileName, 'rt')
    lines = asmFile.readlines()
    asmFile.close()
    
    outFileName = sys.argv[2]
    outFile = open(outFileName, 'wb')
    
    program = bytearray() # lower 4 bits used of each byte
    ifStacks = { }
    sectionIndices = { }
    gotos = [ ] # (index, name)
    
    lineNum = 0
    for line in lines:
        lineNum += 1
        if len(program ) > 4096:
            error(lineNum, "Program is too large")
            break
        words = [w.strip().lower() for w in line.strip().split()]
        if len(words) == 0:
            continue
        command = words[0]
        if command == 'nop':
            program += bytes([0])
        elif command == 'set':
            program += bytes([1])
            program += bytes([int(words[1])])
            program += bytes([int(words[2])])
        elif command == 'clf':
            program += bytes([2])
        elif command == 'tog':
            program += bytes([3])
        elif command == 'inc':
            program += bytes([4])
            program += bytes([int(words[1])])
        elif command == 'dec':
            program += bytes([5])
            program += bytes([int(words[1])])
        elif command == 'if':
            if len(words) > 1:
                code = words[1]
            else:
                code = 'default'
            if code not in ifStacks:
                ifStacks[code] = [ ]
            program += bytes([6])
            ifStacks[code].append(len(program))
            program += bytes([0])
        elif command == 'endif':
            if len(words) > 1:
                code = words[1]
            else:
                code = 'default'
            i = ifStacks[code].pop()
            jumpAmount = len(program) - i - 1
            if jumpAmount > 15:
                error(lineNum, "Jump amount too large")
                break
            program[i] = jumpAmount
        elif command == 's':
            programLen = len(program)
            if programLen % 16 != 0:
                fillerToAdd = 16 - (programLen % 16)
                program += bytes([0] * fillerToAdd)
            sectionIndex = len(program) // 16
            sectionName = words[1]
            print(sectionName, sectionIndex)
            sectionIndices[sectionName] = sectionIndex
        elif command == 'goto':
            program += bytes([7])
            gotos.append((len(program),words[1]))
            program += bytes([0, 0])
        elif command == 'wait':
            program += bytes([8])
        elif command == 'but':
            program += bytes([9])
            program += bytes([int(words[1])])
        elif command == 'butf':
            program += bytes([10])
            program += bytes([int(words[1])])
        elif command == 'knob':
            if words[1] == 'a':
                program += bytes([11])
            elif words[1] == 'b':
                program += bytes([12])
            else:
                error(lineNum, "Unknown knob")
                break
            program += bytes([int(words[2])])
        elif command == 'draw':
            program += bytes([13])
            pair = int(words[1])
            color = int(words[2])
            program += bytes([pair * 4 + color])
        elif command == 'read':
            program += bytes([14])
            pair = int(words[1])
            color = int(words[2])
            program += bytes([pair * 4 + color])
        elif command == 'beep':
            program += bytes([15])
        elif command == 'c':
            pass
        else:
            error(lineNum, "Unrecognized command")
            break
    
    for g in gotos:
        sectionIndex = sectionIndices[g[1]]
        i = g[0]
        program[i] = sectionIndex // 16
        program[i+1] = sectionIndex % 16
    
    condensedProgram = bytearray()
    upper = -1
    for i in range(0, len(program)):
        if i % 2 == 0:
            upper = program[i]
        else:
            b = upper * 16 + program[i]
            condensedProgram += bytes([b])
            upper = -1
    if upper != -1:
        condensedProgram += bytes([upper * 16])
    
    print(binascii.hexlify(condensedProgram))
    
    outFile.write(condensedProgram)
    outFile.close()

