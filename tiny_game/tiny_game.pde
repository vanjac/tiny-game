byte[] program;
int pc = 0;
boolean flag = false;
byte[] registers = new byte[8];

boolean[] buttons = new boolean[8];
boolean[] buttonFlipFlops = new boolean[8];
byte[] knobs = new byte[2];

byte readProgram(int i) {
  byte pairB = program[i / 2];
  int pair = pairB & 0xFF;
  if(i % 2 == 0) {
    return (byte) (pair / 0x10);
  } else {
    return (byte) (pair & 0x0F);
  }
}

void setup() {
  size(256, 256);
  background(0);
  program = loadBytes("hexTest");
  for(int i = 0; i < program.length * 2; i++)
    println(readProgram(i));
}

void draw() {
  boolean frameComplete = false;
  while(!frameComplete) {
    if(pc >= program.length * 2)
      break;
    byte c = readProgram(pc);
    
    byte register, button, knobPos, arg, pixelColor;
    int jump;
    switch(c) {
      case 1: // set register
        println("Set register");
        register = readProgram(++pc);
        registers[register] = readProgram(++pc);
        break;
      case 2: // reset flag
        println("Reset flag");
        flag = false;
        break;
      case 3: // toggle flag
        println("Toggle flag");
        flag = true;
        break;
      case 4: // increment register
        println("Increment register");
        register = readProgram(++pc);
        if(++registers[register] > 15) {
          registers[register] = 0;
          flag = true;
        }
        break;
      case 5: // decrement register
        println("Decrement register");
        register = readProgram(++pc);
        if(--registers[register] < 0) {
          registers[register] = 15;
          flag = true;
        }
        break;
      case 6: // conditional
        println("Conditional");
        jump = readProgram(++pc);
        if(flag) {
          flag = false;
        } else {
          pc += jump - 1;
        }
        break;
      case 7: // jump
        println("Jump");
        jump = readProgram(++pc);
        jump *= 16;
        jump += readProgram(++pc);
        pc = jump - 1;
        break;
      case 8: // wait for frame
        println("Wait for frame");
        frameComplete = true;
        break;
      case 9: // check button
        println("Check button");
        button = readProgram(++pc);
        if(buttons[button])
          flag = true;
        break;
      case 10: // check button flip flop
        println("Check button flip flop");
        button = readProgram(++pc);
        if(buttonFlipFlops[button]) {
          flag = true;
          buttonFlipFlops[button] = false;
        }
        break;
      case 11: // check knob A
        println("Check knob A");
        register = readProgram(++pc);
        knobPos = readKnob(0);
        register += knobPos - knobs[0];
        knobs[0] = knobPos;
        break;
      case 12: // check knob B
        println("Check knob B");
        register = readProgram(++pc);
        knobPos = readKnob(1);
        register += knobPos - knobs[1];
        knobs[1] = knobPos;
        break;
      case 13: // draw pixel
        println("Draw pixel");
        arg = readProgram(++pc);
        register = (byte)((arg / 4) * 2);
        pixelColor = (byte)(arg & 3);
        drawPixel(pixelColor, registers[register], registers[register+1]);
        break;
      case 14: // check pixel
        println("Check pixel");
        arg = readProgram(++pc);
        register = (byte)((arg / 4) * 2);
        pixelColor = (byte)(arg & 3);
        if(pixelColor == readPixel(registers[register], registers[register+1]))
          flag = true;
        break;
    }
    
    pc++;
  }
}