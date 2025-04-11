ORG 0
Init:
	Loadi 	0
	Store	Value
	Store	Score
	Out		Hex1
	
Wait:
	In 		Switches
	JZero	Time
	Jump	Wait
Time:
	Load 	Value
    Addi 	1
    Store 	Value
	IN 		Switches
	Sub		Bit9
	JZero 	Calc
	Jump 	Time
Calc:
	Load 	Value
	And 	Bit08
	JZero	Modify
Send:
	Store 	Value ; we get the target RNG value
	Out 	Hex0
	In		Timer
	Store 	StartTime
Done:
	In 		Switches
	Sub 	Bit9
	JZero 	Done
	jump 	Finder

Correct:
	In 		Timer
	Store 	EndTime
	Loadi	100
	Sub		EndTime
	Add		StartTime
	JNeg	ModScore
UpdateScore:
	Add 	Score
	Store 	Score
	Out		Hex1
	Jump	Wait
ModScore:
	Loadi	0
	Jump	UpdateScore

Finder:
	JZero ErrorState
	Store Temp 
Rest:

	loadi 1
	out PWM
	loadi 0
	out PWM

	loadi &b10
	out PWM
	loadi 0
	out PWM

	loadi &b100
	out PWM
	loadi 0
	out PWM

	loadi &b1000
	out PWM
	loadi 0
	out PWM

	loadi &b10000
	out PWM
	loadi 0
	out PWM

	loadi &b100000
	out PWM
	loadi 0
	out PWM

	loadi &b1000000
	out PWM
	loadi 0
	out PWM

	loadi &b10000000
	out PWM
	loadi 0
	out PWM

	loadi &b100000000
	out PWM
	loadi 0
	out PWM

	loadi &b1000000000
	out PWM
	loadi 0
	out PWM
	
	
	loadi 1
	store LED
	in switches
	sub Bit9
	sub Value
	jzero Correct
	store temp
	jneg abs
	store Error
	jump pos
abs:
	loadi 0
	sub temp
	store Error

pos:
	loadi 128
	sub Error
	jpos change
	loadi 128
	store Error
change:
	loadi 128
	sub Error
	store Error
LEDS_:
	loadi 16
	sub Error
	
	jpos Remainder
	jzero Zero
	
	load LED
	out PWM
	
	loadi &h64
	out PWM
	
	load LED
	shift 1
	store LED
	
	load Error
	add Negsixteen
	store Error
	
	jump LEDS_

Zero:
	loadi &h64
	store Error
	
Remainder:
	load LED
	out PWM
	load Error
	out PWM
	jump Rest

Modify:
	Addi 	511
	Jump	Send

ErrorState:
	jump ErrorState
	
; Variables
	Value:		DW 0
	Score:		DW 0
	StartTime:	DW 0
	EndTime:	DW 0
	SwitchRes: 	DW 0
	; Useful values
	Bit08:		DW &B0111111111
	Bit9:      	DW &B1000000000
	One: 		DW 		1
	Temp: 		DW 		0
	Count: 		DW 		-1
	NegOne: 	DW 		-1
	Negsixteen:	DW	-16
	Error: 		DW	128
	LED:		DW	1
	; IO address constants
	Switches:  EQU 000
	LEDs:      EQU 001
	Timer:     EQU 002
	Hex0:      EQU 004
	Hex1:	   EQU 005
	PWM:	   EQU 032
	reset_Ctrl_state:	DW &b1000000000000000
