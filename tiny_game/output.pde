import processing.sound.*;

final color COLOR0 = color(0,0,0);
final color COLOR1 = color(0,127,255);
final color COLOR2 = color(255,127,0);
final color COLOR3 = color(255,255,255);
final color COLOR_ERROR = color(255,0,255);

final float[] FREQUENCIES = new float[] {
  261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99,
  392.00, 415.30, 440.00, 466.16, 493.88, 523.25, 554.37, 587.33 };

SqrOsc oscillator;

void initSound() {
  oscillator = new SqrOsc(this);
  oscillator.amp(0.5);
}

void updateSound() {
  if (registers[12] != 0) {
    oscillator.play();
    oscillator.freq(FREQUENCIES[registers[12] - 1]);
  } else {
    oscillator.stop();
  }
}

void drawPixel(int c, int x, int y) {
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

int readPixel(int x, int y) {
  int xPos = (int)((x + 0.5) * width / 16);
  int yPos = (int)((y + 0.5) * height / 16);
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
