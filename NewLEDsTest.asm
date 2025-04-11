ORG 0

loop:
in switches
jzero loop

Next:
out PWM

go:
shift -1
jzero inc0
shift -1
jzero inc1
shift -1
jzero inc2
shift -1
jzero inc3
shift -1
jzero inc4
shift -1
jzero inc5
shift -1
jzero inc6
shift -1
jzero inc7
shift -1
jzero inc8
shift -1
jzero inc9

error:
jump error

inc0:
load b0
addi &h8 ; currently increases brightness by 12.5%
store b0
out PWM
jump wait

inc1:
load b1
addi &h8
store b1
out PWM
jump wait

inc2:
load b2
addi &h8
store b2
out PWM
jump wait

inc3:
load b3
addi &h8
store b3
out PWM
jump wait

inc4:
load b4
addi &h8
store b4
out PWM
jump wait

inc5:
load b5
addi &h8
store b5
out PWM
jump wait

inc6:
load b6
addi &h8
store b6
out PWM
jump wait

inc7:
load b7
addi &h8
store b7
out PWM
jump wait

inc8:
load b8
addi &h8
store b8
out PWM
jump wait

inc9:
load b9
addi &h8
store b9
out PWM
jump wait

wait:
in switches
jzero loop
jump wait


end:
jump end

; variables for brightness levels
b0: 		DW 0
b1: 		DW 0
b2: 		DW 0
b3: 		DW 0
b4: 		DW 0
b5: 		DW 0
b6: 		DW 0
b7: 		DW 0
b8: 		DW 0
b9: 		DW 0


Switches:  	EQU 000
LEDs:      	EQU 001
Timer:     	EQU 002
Hex0:      	EQU 004
Hex1:      	EQU 005
PWM:		EQU 032
reset_Ctrl_state:	DW &b1000000000000000
