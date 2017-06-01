4 bit

## State

- 12 bit program counter
- 16x16 pixel, 4 color screen with buffer
- Flag
- Memory: 8x 4-bit registers. Also grouped by 4 pairs.
- Flip/flops for each button. Set when button is pressed.
- Last knob position for each knob.

## Input for each player

- Knob (16 positions)
- 4 buttons

## Other controls

- Speed
- Reset (doesn't clear registers)
- Pause

## Commands

All values and arguments are 4 bit values.

- `0` No op
  - `NOP`
- `1 [register] [value]` Set register
  - `SET register value`
- `2` Reset flag
  - `CLF`
- `3` Toggle flag
  - `TOG`
- `4 [register]` Increment register. Set flag on overflow.
  - `INC register`
- `5 [register]` Decrement register. Set flag on underflow. (NOT TESTED)
  - `DEC register`
- `6 [jump amount]` If flag, clear flag, else skip over `jump amount` instructions.
  - `IF letter`
  - `ENDIF letter`
- `7 [upper][lower]` Set upper 8 bits of program counter to `upper + lower`, and lower 4 bits to 0
  - `S name`
  - `GOTO name`
- `8` Wait for speed tick
  - `WAIT`
- `9 [button]` Set flag if button is pressed
  - `BUT button`
- `A [button]` Set flag if button flip flop is set. Reset flip flop. (NOT TESTED)
  - `BUTF button`
- `B [register]` Add change in knob A since last check to register, reset knob change counter. Flag on overflow.
  - `KNOB A register`
- `C [register]` knob B
  - `KNOB B register`
- `D [code]` Read the register pair given by the upper 2 bits of `code`. Draw a pixel at the X/Y position given by the register pair, with the color given by the lower 2 bits of `code`.
  - `DRAW pair color`
- `E [code]` Similar to `D`, but instead of drawing set the flag if the pixel matches the color.
  - `READ pair color`
- `F` Beep
  - `BEEP`
