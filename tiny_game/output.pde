void drawPixel(byte c, byte x, byte y) {
  switch(c) {
    case 0:
      fill(0,0,0);
      break;
    case 1:
      fill(255, 0, 0);
      break;
    case 2:
      fill(0, 255, 0);
      break;
    case 3:
      fill(255, 255, 0);
      break;
    default:
      fill(255, 255, 255);
      break;
  }
  rect(x * width / 16, y * width / 16, width / 16, width / 16);
}

byte readPixel(byte x, byte y) {
  return 0;
}