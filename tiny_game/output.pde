final color COLOR0 = color(0,0,0);
final color COLOR1 = color(255,0,0);
final color COLOR2 = color(0,255,0);
final color COLOR3 = color(255,255,0);
final color COLOR_ERROR = color(255,255,255);

void drawPixel(byte c, byte x, byte y) {
  switch(c) {
    case 0:
      fill(COLOR0);
      break;
    case 1:
      fill(COLOR1);
      break;
    case 2:
      fill(COLOR2);
      break;
    case 3:
      fill(COLOR3);
      break;
    default:
      fill(COLOR_ERROR);
      break;
  }
  rect(x * width / 16, y * height / 16, width / 16, height / 16);
}

byte readPixel(byte x, byte y) {
  int xPos = (int)((x * 0.5) * width / 16);
  int yPos = (int)((y * 0.5) * height / 16);
  color c = get(xPos, yPos);
  if(c == COLOR0)
    return 0;
  if(c == COLOR1)
    return 1;
  if(c == COLOR2)
    return 2;
  if(c == COLOR3)
    return 3;
  return -1;
}