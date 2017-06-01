byte readKnob(int knob) {
  if(knob == 0)
    return (byte)(mouseX * 16 / width);
  else
    return (byte)(mouseY * 16 / height);
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