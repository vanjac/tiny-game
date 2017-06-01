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
  byte ret;
  if(i % 2 == 0) {
    ret = (byte) (pair / 0x10);
  } else {
    ret = (byte) (pair & 0x0F);
  }
  println(ret);
  return ret;
}

void setup() {
  size(256, 256);
  background(0);
  program = loadBytes("hexTest");
}

void keyPressed() {
  switch(key) {
    case 'a':
      buttons[0] = true;
      buttonFlipFlops[0] = true;
      break;
    case 's':
      buttons[1] = true;
      buttonFlipFlops[1] = true;
      break;
    case 'd':
      buttons[2] = true;
      buttonFlipFlops[2] = true;
      break;
    case 'f':
      buttons[3] = true;
      buttonFlipFlops[3] = true;
      break;
    case 'z':
      buttons[4] = true;
      buttonFlipFlops[4] = true;
      break;
    case 'x':
      buttons[5] = true;
      buttonFlipFlops[5] = true;
      break;
    case 'c':
      buttons[6] = true;
      buttonFlipFlops[6] = true;
      break;
    case 'v':
      buttons[7] = true;
      buttonFlipFlops[7] = true;
      break;
  }
}


void keyReleased() {
  switch(key) {
    case 'a':
      buttons[0] = false;
      break;
    case 's':
      buttons[1] = false;
      break;
    case 'd':
      buttons[2] = false;
      break;
    case 'f':
      buttons[3] = false;
      break;
    case 'z':
      buttons[4] = false;
      break;
    case 'x':
      buttons[5] = false;
      break;
    case 'c':
      buttons[6] = false;
      break;
    case 'v':
      buttons[7] = false;
      break;
  }
}

void draw() {
  int i = 0;
  boolean frameComplete = false;
  while(!frameComplete) {
    if(pc >= program.length * 2)
      break;
    
    if(i++ > 32) {
      println("Too many instructions!");
      break;
    }
    println("--------");
    
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
        flag = !flag;
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
          pc += jump;
        }
        break;
      case 7: // jump
        println("Jump");
        jump = readProgram(++pc);
        jump *= 16;
        jump += readProgram(++pc);
        jump *= 16;
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
        registers[register] += knobPos - knobs[0];
        knobs[0] = knobPos;
        if(registers[register] > 15) {
          registers[register] = 0;
          flag = true;
        }
        break;
      case 12: // check knob B
        println("Check knob B");
        register = readProgram(++pc);
        knobPos = readKnob(1);
        registers[register] += knobPos - knobs[1];
        knobs[1] = knobPos;
        if(registers[register] > 15) {
          registers[register] = 0;
          flag = true;
        }
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