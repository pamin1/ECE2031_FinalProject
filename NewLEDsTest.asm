ORG 0

loadi &b0000000001 ;choose right most LED
out PWM
loadi &h64 ;100%
out PWM

loadi &b0000111000 ;choose 3 LEDs 3 from right
out PWM
loadi &h32 ;50%
out PWM

loadi &b1100000000 ;choose left 2 most LED
out PWM
load reset_Ctrl_state ;reset state to LED select
out PWM
loadi &b0010000000 ;choose 3rd from left LED
out PWM
loadi &h16 ;25%
out PWM

loop:
jump loop

PWM: 	EQU 032
reset_Ctrl_state:	DW &b1000000000000000