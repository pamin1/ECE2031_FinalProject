ORG 0
Init:
	Loadi 	0
	Store	Value
	Store	Score
	Out		Hex1
	call 	Low

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
	Loadi	200
	Sub		EndTime
	Add		StartTime
	JNeg	ModScore
UpdateScore:
	Add 	Score
	Store 	Score
	Out		Hex1
	Jump	Looper
ModScore:
	Loadi	0
	Jump	UpdateScore

Finder:
	JZero ErrorState
	Store Temp 
Rest:
	call Low	
	
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
	
Looper:
	call Low
	loadi 33
	store temp1
	loadi 0
	store temp2
	store Counter
WinPattern:
	in Switches
	jzero Init

	load temp1
	out PWM
	load temp2
	out PWM
	addi 10
	store temp2
	addi -100
	store temp2
	jzero ShiftTemp
	call Delay
	
	load temp2
	addi 100
	store temp2
	
	jump WinPattern
	
ShiftTemp:
	load temp1
	shift 1
	store temp1
	load Counter
	addi 1
	store Counter
	addi -5
	jzero Looper
	
	loadi 0
	store temp2
	jump WinPattern
	
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoop
	RETURN
	
Low:
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
	RETURN
	
	
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
	Counter: 	DW 	0
	i:			DW 	0
	temp1:		DW 	1
	temp2:		DW 	0
	; IO address constants
	Switches:  EQU 000
	LEDs:      EQU 001
	Timer:     EQU 002
	Hex0:      EQU 004
	Hex1:	   EQU 005
	PWM:	   EQU 032
	reset_Ctrl_state:	DW &b1000000000000000
