final int CYCLES_PER_FRAME = 64;
final boolean DEBUG = false;

byte[] program;
boolean[] flags = new boolean[16];
byte[] registers = new byte[16];

void setup() {
  size(256, 256);
  background(0);
  selectInput("Choose a ROM file:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null)
    exit();
  else
    program = loadBytes(selection.getAbsolutePath());
}

void draw() {
  if (program == null || getProgramCounter() > program.length)
    return;
  
  flags[5] = true;
  updateInput();
  
  for (int i = 0; i < CYCLES_PER_FRAME; i++) {
    if (DEBUG) print(hex(getProgramCounter()) + " ");
    int instr = readProgram(getProgramCounter());
    int op = instr >> 4;
    int arg = instr & 0x0f;

    int instr2, x, y;
    switch (op) {
      case 0:
        if (DEBUG) println("No op");
        break;
      case 1: // conditional
        if (DEBUG) println("Conditional");
        if (flags[arg]) {
          flags[arg] = false;
        } else {
          for (int j = 0; j < 4; j++)
            incrProgramCounter();
        }
        break;
      case 2: // reset flag
        if (DEBUG) println("Reset flag");
        flags[arg] = false;
        break;
      case 3: // toggle flag
        if (DEBUG) println("Toggle flag");
        flags[arg] = !flags[arg];
        break;
      case 4: // increment register
        if (DEBUG) println("Increment register");
        if (++registers[arg] > 15) {
          registers[arg] = 0;
          flags[0] = true;
        }
        break;
      case 5: // decrement register
        if (DEBUG) println("Decrement register");
        if (--registers[arg] < 0) {
          registers[arg] = 15;
          flags[0] = true;
        }
        break;
      case 6: // set register
        if (DEBUG) println("Set register");
        instr2 = readProgram(incrProgramCounter());
        registers[arg] = (byte)(instr2 & 0x0f);
        i++; // 2 cycles
        break;
      case 7: // set pair
        if (DEBUG) println("Set pair");
        instr2 = readProgram(incrProgramCounter());
        registers[arg] = (byte)(instr2 & 0x0f);
        registers[(arg + 1) % 16] = (byte)(instr2 >> 4);
        i++; // 2 cycles
        break;
      case 8: // draw pixel
      case 9:
      case 10:
      case 11:
        if (DEBUG) println("Draw pixel");
        x = registers[arg];
        y = registers[(arg + 1) % 16];
        drawPixel(op & 3, x, y);
        i++; // 2 cycles
        break;
      case 12: // check pixel
      case 13:
      case 14:
      case 15:
        if (DEBUG) println("Check pixel");
        x = registers[arg];
        y = registers[(arg + 1) % 16];
        if ((op & 3) == readPixel(x, y))
          flags[1] = true;
        i++; // 2 cycles
        break;
    }
    
    incrProgramCounter();
  }
}

int readProgram(int addr) {
  if (addr >= program.length)
    return 0;
  return program[addr] & 0xff;
}

int getProgramCounter() {
  return registers[15] + (registers[14] << 4) + (registers[13] << 8);
}

int incrProgramCounter() {
  registers[15]++;
  if (registers[15] > 15) {
    registers[15] = 0;
    registers[14]++;
    if (registers[14] > 15) {
      registers[14] = 0;
      registers[13]++;
      if (registers[13] > 15)
        registers[13] = 0;
    }
  }
  
  return getProgramCounter();
}
