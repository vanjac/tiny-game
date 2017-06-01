byte readKnob(int knob) {
  if(knob == 0)
    return (byte)(mouseX / 16);
  else
    return (byte)(mouseY / 16);
}