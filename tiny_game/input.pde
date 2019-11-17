int knobAError;
int knobBError;

void updateInput() {
  knobAError += mouseX - pmouseX;
  while (knobAError > width/16) {
    knobAError -= width/16;
    incrKnob(8, 6);
  }
  while (knobAError < -width/16) {
    knobAError += width/16;
    decrKnob(8, 6);
  }
  knobBError += mouseY - pmouseY;
  while (knobBError > width/16) {
    knobBError -= width/16;
    incrKnob(10, 7);
  }
  while (knobBError < -width/16) {
    knobBError += width/16;
    decrKnob(10, 7);
  }
}

void incrKnob(int register, int flag) {
  registers[register]++;
  if (registers[register] > 15) {
    registers[register] = 0;
    flags[flag] = true;
  }
}

void decrKnob(int register, int flag) {
  registers[register]--;
  if (registers[register] < 0) {
    registers[register] = 15;
    flags[flag] = true;
  }
}

void keyPressed() {
  switch(key) {
    case 'a':
      flags[8] = true;
      break;
    case 'd':
      flags[9] = true;
      break;
    case 'w':
      flags[10] = true;
      break;
    case 'x':
      flags[11] = true;
      break;
    case '4':
      flags[12] = true;
      break;
    case '6':
      flags[13] = true;
      break;
    case '8':
      flags[14] = true;
      break;
    case '2':
      flags[15] = true;
      break;
  }
}

void keyReleased() {
  switch(key) {
    case 'a':
      flags[8] = false;
      break;
    case 'd':
      flags[9] = false;
      break;
    case 'w':
      flags[10] = false;
      break;
    case 'x':
      flags[11] = false;
      break;
    case '4':
      flags[12] = false;
      break;
    case '6':
      flags[13] = false;
      break;
    case '8':
      flags[14] = false;
      break;
    case '2':
      flags[15] = false;
      break;
  }
}
