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
- `1 [register] [value]` Set register
- `2` Reset flag
- `3` Toggle flag
- `4 [register]` Increment register. Set flag on overflow.
- `5 [register]` Decrement register. Set flag on underflow.
- `6 [jump amount]` If flag, clear flag, else jump forward
- `7 [upper][lower]` Set upper 8 bits of program counter to `upper + lower`, and lower 4 bits to 0
- `8` Wait for speed tick
- `9 [button]` Set flag if button is pressed
- `A [button]` Set flag if button flip flop is set. Reset flip flop.
- `B [register]` Add change in knob A since last check to register, reset knob change counter. Flag on overflow.
- `C [register]` knob B
- `D [code]` Read the register pair given by the upper 2 bits of `code`. Draw a pixel at the X/Y position given by the register pair, with the color given by the lower 2 bits of `code`.
- `E [code]` Similar to `D`, but instead of drawing set the flag if the pixel matches the color.
- `F` Beep
