ORG 0

loop:
loadi &b111000111
out PWM
jump loop

PWM: 	EQU 032
