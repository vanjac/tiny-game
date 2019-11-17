Virtual console

- 4-bit "cpu"
- 16x16 pixel, 4 color screen
- 8 buttons (4 per player), 2 knobs (1 per player)
- Single square wave with 15 pitches

Other controls:
- Speed select (pause, third, half, full)
- Reset button (doesn't clear registers)

## Memory

- 16 registers (r0 - r15)
    - When knob A is rotated it increments/decrements r8. Knob B changes r10.
    - r12 changes the sound pitch (0 is off)
    - r13-15 store program counter. **Instructions are addressed by byte rather than by nibble.**
- 16 flags (f0 - f11)
    - f0 is set by increment/decrement instructions
    - f1 is set by pixel test instructions
    - f5 is set either 20, 30, or 60 frames per second depending on speed setting
    - f6/f7 are set when twisting the knob causes the register to overflow
    - f8-f15: button flags, set when button is pressed and reset when released, but not changed otherwise
- Screen buffer (16x16, 2 bits per pixel)

## Commands

All values and arguments are 4 bit values. Most instructions are 8 bits, some are 16 bits.

- `LBL label` to mark a label

- `0 [ignore]` No op
  - `NOP`
- `1 [flag]` If NOT flag, increment program counter by 4 bytes (8 nibbles, 4 instructions).
  - `IFF flag`
- `2 [flag]` Reset flag
  - `CLF flag`
- `3 [flag]` Toggle flag
  - `TOG flag`
- `4 [register]` Increment register. Set f0 on overflow.
  - `INC register`
- `5 [register]` Decrement register. Set f0 on overflow.
  - `DEC register`
- `6 [register] [ignore] [value]` Set register
  - `SET register value`
- `7 [register] [value2] [value1]` Set register pair (register and following)
  - `SPR register value1 value2`
  - `JMP label` (for program counter)
- `8/9/A/B [register]` Draw a pixel at the X/Y position given by the register pair. 4 instructions for 4 possible colors.
  - `DPX pair color`
- `C/D/E/F [register]` Similar to above, but instead of drawing set f1 if the pixel matches the color.
  - `RPX pair color`
