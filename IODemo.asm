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
	Store 	Value
	Out 	Hex0
	In		Timer
	Store 	StartTime
Done:
	In 		Switches
	Sub 	Bit9
	JZero 	Done
	Call 	Finder
	Store 	SwitchRes
	In 		Timer
	Store 	EndTime
Guess:
	Load	Value
	Call 	Finder
	Sub 	SwitchRes
	JZero	Correct
	Jump 	Init
Correct:
	Loadi	20
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
	JZero Error
	Store Temp
Rest:
	Load Count
	Add One
	Store Count
	Load Temp
	And One
	JPos Found

Shifter:
Load Temp
Shift -1
Store Temp
Jump Rest

Found:
Load Count
Store Temp
Load NegOne
Store Count
Load Temp
RETURN

Error:
Load NegOne
Store Temp
RETURN

	
	
Modify:
	Addi 	511
	Jump	Send

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


	; IO address constants
	Switches:  EQU 000
	LEDs:      EQU 001
	Timer:     EQU 002
	Hex0:      EQU 004
	Hex1:	   EQU 005
	Jump 	Wait
