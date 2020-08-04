//   PROJECT PART 2 
//   CPSC 355 Spring 2020
//   Submitted by : Priyavart Rajain
//   UCID 30074184 

		.data											/*data section, writing to memory*/

response:	.word 0											// User response, whether to continue playing or quit
i_coord:	.word 0											// i coordinate
j_coord:	.word 0											// j coordinate
twelve:		.double 0r12.00										// storing 12.00 for later use
pointTwelve:	.double 0r0.12										// storing 0.12 for later use
pointTwo:	.double	0r0.20										// storing 0.20 for later use
zero:		.double 0r0.0										// storing 0.0 for later use
one:		.double 0r1.0										// storing 1.0 for later use
five:		.double 0r5.0										// storing 5.0 for later use
ten:		.double 0r10.00										// storing 10.0 for later use
hundred:	.double 0r100.0										// storing 100.0 for later use
randMax:	.double 0r32767.0									// storing 32767.0 for later use
twenty:		.double 0r20.00										// storing 20.00 for later use
twentyOne:	.double 0r21.00										// storing 21.00 for later use
twentyTwo:	.double 0r22.00										// storing 22.00 for later use
twentyThree:	.double 0r23.00										// storing 23.00 for later use

		.text											/* text section*/

fp		.req	x29										// defining fp for x29 
lr		.req	x30										// defining lr for x30

initialTable:	.string	"Initial Table:\n"								// initial table string
scoreString:	.string "Score:    %.2f\n"								// score string
newLine:	.string "\n"										// new line string
timeString:	.string "Time:	   %.2f\n"								// time string 
greeting:	.string "\n\nHello %s, Below is the initial game board: \n\n"				// greeting the user when the game begins
endgreet:	.string "\n\nThanks for playing %s, Below is your score and time taken: \n\n"		// string for exitGame function
endTime:	.string "Time taken: %.2f\n"								// string to display time
formatIn:	.string "%d"										// format string for scanf
elem_fmt:	.string "%.2f  "									// string to print table eleements
movePrompt:	.string "Enter your move ( x , y ):	"						// prompt the user to make a move	
inputMove:	.string "%d %d"										// format string to take the coordinates as input 
rewardString:	.string "\nUncovered a reward of %.2f points\n\n"					// reward string 
bombString:	.string "\nOops, You lost %.2f points\n\n"						// bomb string 
cellDiscovered:	.string "\nCell already discovered, make another choice\n\n"				// cell has been discovered string 
niceSurpString:	.string "\nYou discovered a nice surprise, score will be doubled.\n\n"			// nice surprise string 
badSurpString:	.string "\nYou discovered a bad surprise, score will be halved.\n\n"			// bad surprise string 
timePackString:	.string "\nYou discovered a time pack. 10 seconds will be added to the timer\n\n"	// time pack string 
bombSign:	.string "- "										// the bomb sign 
rewardSign:	.string "+ "										// the reward sign 
badSurpSign:	.string "! "										// bad surprise string 
goodSurpSign:	.string "$ "										// good surprise string 
timePackSign:	.string "@ "										// time pack string 
undiscovered:	.string "X "										// undiscovered cells denoted by X
blank:			.string " "									// empty string

err1:		.string "\nPlease enter the player name followed by the dimension of the game board\n"	// error 1, invalid arguments supplied
err2:		.string "Board dimensions too small, enter a value between 5 and 20\n"			// error 2, board dimensions < 5
err3:		.string "Board dimensions too big, enter a value between 5 and 20\n"			// error 3, board dimensions >20
err4:		.string "Please enter valid coordinates:    "						// invalid coordinates

gameOver1:	.string "\nTime Up. Game Over\n"							// game over condition 1 				
gameOver2:	.string "Score went below 0. Game Over\n"						// game over condition 2
gameOver3:	.string "\nAll cells have been discovered. Game Over\n"					// game over condition 3

decide:		.string "\nPress 1 to quit or any other key to continue:    "				// prompt user to choose whether to continue or quit
responseSize=		4										// int response size 
firstMoveSize=		4										// int first move size
i_coordSize=		4										// int i coordinate size
j_coordSize=		4										// int j coordinate size
allDiscoveredSize=	4										// int allDiscovered size
surpriseCountSize=	4										// int surprise count size

scoreSize=		8										// double score size 
timeRemSize=		8										// double time remaining size
totalTimeSize=		8										// double total time allocated size
totalSurpriseSize=	4										// int total surprise count allowed size
playerNameSize=		32										// string player name size
table_size=		1600										// float table size 20 x 20

table_s=		4										// table offset from fp towards lower memory address
time_rem_s=		table_s+ table_size								// time remaining offset from fp 
total_time_s=		time_rem_s+ timeRemSize								// total time offset from fp
total_surprise_s=	total_time_s+ totalTimeSize							// total surprise offset from fp
playerName_s=		total_surprise_s+ totalSurpriseSize						// player name offset from fp
score_s=		playerName_s+ playerNameSize							// score offset from fp

													/* Specifying the size of 64 bit registers so that memory can be 
													   allocated for them at various points in the code e.g. inside subroutines 
													   64 bit register size = 8 bytes */
x19_size=		8																								
x20_size=		8
x21_size=		8
x22_size=		8
x23_size=		8
x24_size=		8
x25_size=		8
x26_size=		8
x27_size=		8
x28_size=		8
													/* Specifying the size of double floating point registers so that memory can be 
													   allocated for them at various points in the code e.g. inside subroutines 
													    double precision floating point register size = 8 bytes */ 
d8_size=		8
d9_size=		8
d10_size=		8
d11_size=		8
d12_size=		8
d13_size=		8
d14_size=		8
d15_size=		8

response_s=		16										// response offset from fp towards higher memory addresses 
firstMove_s=		response_s+ responseSize							// first move offset from fp towards higher memory addresses 
i_coord_s=		firstMove_s+ firstMoveSize							// i coordinate offset from fp towards higher memory addresses 
j_coord_s=		i_coord_s+ i_coordSize								// j coordinate offset from fp towards higher memory addresses
allDiscovered_s= 	j_coord_s+ j_coordSize								// all discovered offset from fp towards higher memory addresses 
surpriseCount_s= 	allDiscovered_s+ allDiscoveredSize						// surprise count offset from fp towards higher memory addresses

x19_s=			surpriseCount_s+ surpriseCountSize						// offset for x19 from fp towards higher memory address
x20_s=			x19_s+ x19_size									// offset for x20 from fp towards higher memory address
x21_s=			x20_s+ x20_size									// offset for x21 from fp towards higher memory address
x22_s=			x21_s+ x21_size									// offset for x22 from fp towards higher memory address
x23_s=			x22_s+ x22_size									// offset for x23 from fp towards higher memory address
x24_s=			x23_s+ x23_size									// offset for x24 from fp towards higher memory address
x25_s=			x24_s+ x24_size									// offset for x25 from fp towards higher memory address
x26_s=			x25_s+ x25_size									// offset for x26 from fp towards higher memory address
x27_s=			x26_s+ x26_size									// offset for x27 from fp towards higher memory address
x28_s=			x27_s+ x27_size									// offset for x28 from fp towards higher memory address

d8_s=			x28_s+ x28_size									// offset for d8 from fp towards higher memory address
d9_s=			d8_s+ d8_size									// offset for d9 from fp towards higher memory address
d10_s=			d9_s+ d9_size									// offset for d10 from fp towards higher memory address
d11_s=			d10_s+ d10_size									// offset for d11 from fp towards higher memory address
d12_s=			d11_s+ d11_size									// offset for d12 from fp towards higher memory address
d13_s=			d12_s+ d12_size									// offset for d13 from fp towards higher memory address
d14_s=			d13_s+ d13_size									// offset for d14 from fp towards higher memory address
d15_s=			d14_s+ d14_size									// offset for d15 from fp towards higher memory address

udiv_s=			d15_s+ d15_size									// offset to store unsigned division result 
msub_s=			udiv_s+ 4									// offset to store the result of msub
udiv_size=		4										// size of udiv result 
msub_size=		4										// size of msub result 

randMin_size=		8										// randMin size = 8 bytes
randMax_size=		8										// randMax size = 8 bytes
neg_size=		4										// neg_size size = 4 bytes
randfloat_size=		8										// randfloat size = 8 bytes
scale_size=		8										// scale size = 8 bytes
rand_size=		8										// rand result size = 8 bytes

randMin_s=		msub_s+ msub_size								// offset to store rand min 
randMax_s=		randMin_s+ randMin_size								// offset to store rand max
neg_s=			randMax_s+ randMax_size								// offset to store neg value
randfloat_s=		neg_s+ neg_size									// offset to store rand float 
scale_s=		randfloat_s+ randfloat_size							// offset to store scale value
rand_s=			scale_s+ scale_size								// offset to store rand value

allocateMem=		timeRemSize+ totalTimeSize+ totalSurpriseSize+ playerNameSize+table_size	// specifying the memory to allocate on top of fp on the stack, in the lowwer memory ( negation of allocateMem to be added to fp )
deallocateMem=		1664										// memory to be deallocated from the stack 

m_var_size=		responseSize+ firstMoveSize+ i_coordSize+j_coordSize+allDiscoveredSize+surpriseCountSize		 // specifying the amount of memory to be allocated to main
m_alloc=		-(16+ m_var_size)& -16
m_dealloc=		-m_alloc												 // memory to be deallocated from the stack 
		
i_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ x24_size+ x25_size+ x26_size+  udiv_size+msub_size+ d8_size+ d9_size+ d10_size+ d11_size+ d12_size	 // specifying the amount of memory to be allocated to intitializeGame
i_alloc=		-(16+ i_var_size)& -16
i_dealloc=		-i_alloc																																									 // memory to be deallocated from the stack

d_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ x24_size+ d8_size																																		 // specifying the amount of memory to be allocated to display 
d_alloc=		-(16+ d_var_size)& -16	
d_dealloc=		-d_alloc																																									 // memory to be deallocated from the stack
			
	
r_var_size=		randMin_size+ randMax_size+ neg_size+ randfloat_size+ scale_size+ rand_size																																	 // specifying the amount of memory to be allocated to randomNum
r_alloc=		-(16+ r_var_size)& -16
r_dealloc=		-r_alloc																																					 				// memory to be deallocated from the stack

dg_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ d8_size+ d9_size+ d10_size+ d11_size																	 													// specifying the amount of memory to be allocated to displayGame
dg_alloc=		-(16+ dg_var_size)& -16
dg_dealloc=		-dg_alloc																																	       			 			// memory to be deallocated from the stack

c_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ x24_size+ x25_size+ x26_size+ x27_size+ x28_size+ d8_size+ d9_size+ d10_size+ d11_size+ d12_size+ d13_size+ d14_size+ d15_size  // specifying the amount of memory to be allocated to calculateScore
c_alloc=		-(16+ c_var_size)&-16
c_dealloc=		-c_alloc																																												 // memory to be deallocated from the stack

ch_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ x24_size+ x25_size+ x26_size+ x27_size+ d8_size+ d9_size+ d10_size																															 // specifying the amount of memory to be allocated to checkBoard
ch_alloc=		-(16+ ch_var_size)&-16
ch_dealloc=		-ch_alloc																																												// memory to be deallocated from the stack

t_var_size=		x19_size+ x20_size+ x21_size+ d8_size																																									 // specifying the amount of memory to be allocated to timeRem
t_alloc=		-(16+ t_var_size)& -16
t_dealloc=		-t_alloc																																												 // memory to be deallocated from the stack
					
ti_var_size=		x19_size+ x20_size+ x21_size+ x22_size+ x23_size+ x24_size+ x25_size+ x26_size+ x27_size+ x28_size+ d8_size+ d9_size+ d10_size+ d11_size+ d12_size+ d13_size+ d14_size+ d15_size	 
																			// specifying the amount of memory to be allocated to timeBonus
ti_alloc=		-(16+ ti_var_size)& -16
ti_dealloc=		-ti_alloc																																												 // memory to be deallocated from the stack

ex_var_size=		x19_size+ d8_size+ d9_size+ d10_size																																	 // specifying the amount of memory to be allocated to exitGame
ex_alloc=		-(16+ ex_var_size)& -16	
ex_dealloc=		-ex_alloc			  																														  			 // memory to be deallocated from the stack			
			.balign 4			       	                         // align the instructions by 4
			.global main				                         // make globally accessible

//----------D I S P L A Y-------------------			/*This function displays the initially generated table consisting of random floats*/

display:	stp	fp, lr, [sp, d_alloc]!			// allocating memory on the stack for display subroutine
		mov	fp, sp					// updating fp to point to the top of stack 

								/* Storing the required registers at the specified the offsets from fp
								 in the higher memory i.e positively growing addresses */ 
		str	x19, [fp, x19_s]																			
		str	x20, [fp, x20_s]
		str	x21, [fp, x21_s]
		str	x22, [fp, x22_s]
		str	x23, [fp, x23_s]
		str	x24, [fp, x24_s]
		str	d8,  [fp,  d8_s]		
								/* initializing the registers to be used with 0 
								 to make sure they don't have any garbage value */

		mov	x19, 0					// array base address 
		mov	x20, 0					// N
		mov	x21, 0					// i counter 
		mov	x22, 0					// j counter 
		mov	x23, 0					// array element offset 
																					
		mov	x19, x0					// storing the passed argument ( array base address ) in x19
		mov	x20, x1					// storing the passed argument ( N ) in x20

		b	d_outLoopTest				// branch to d_outLoopTest

d_loopBody:	mul	w23, w21, w20				// w23 = i* N
		add	w23, w23, w22				// w23 = (i* N)+ j
		lsl	w23, w23, 3				// w23 = ((i*N)+j )*8
		mov	x24, -1
		SXTW	x23, w23
		mul	x23, x23, x24				// negate w23 because the array is in the lower memory address
		ldr	d8, [x19, x23]				// load the element to d8 
		
		adrp	x0, elem_fmt				// storing address of elem_fmt string in x0 for printing
		add	x0, x0, :lo12:elem_fmt
		fmov	d0, d8					// pass d8 as an argument to printf using d0
		bl	printf					// call printf

		add	w22, w22, 1				// j = j + 1
		b	d_inLoopTest				// branch back to d_inLoopTest to check if j<N

d_inLoopTest:	cmp	w22, w20				// if j < N
		b.lt	d_loopBody				// branch to d_loopBody
		b.ge	d_incrementI				// else branch to d_incrementI

d_incrementI:	add	w21, w21, 1				// i = i + 1
		adrp	x0, newLine				// storing address of newLine string in x0 for printing
		add	x0, x0, :lo12:newLine
		bl	printf					// print a new line character
		mov	w22, 0					// set j = 0 again
		b.ge	d_outLoopTest				// branch to d_outLoopTest

d_outLoopTest:	cmp	w21, w20				// if i < N 
		b.lt	d_inLoopTest				// branch to d_inLoopTest
		b.ge 	d_done					// else branch to done

								/*Loading the registers used back to their respective offsets in memory*/
d_done:		ldr	x19, [fp, x19_s]																		
		ldr	x20, [fp, x20_s]
		ldr	x21, [fp, x21_s]
		ldr	x22, [fp, x22_s]
		ldr	x23, [fp, x23_s]
		ldr	x24, [fp, x24_s]
		ldr	d8,  [fp, d8_s ]
		mov	x0, 0					// setting x0 and x1 back to 0 (optional)																		   
		mov	x1, 0

		ldp	fp, lr, [sp], d_dealloc			/* deallocating memory by popping the frame record from the stack by loading back 	
								the values of fp and lr*/
		ret						// return to calling code





/*--------D I S P L A Y G A M E-------------*/			/* This function displays the table of X's that the user will interact with, aka The game board
								   It also updates the board and inserts the neccessary symbols like bomb and rewards wherever necessary */

displayGame:	stp	fp, lr, [sp, dg_alloc]!			// allocating memory on the stack for displayGame subroutine				
		mov	fp, sp					// update the frame pointer by making it point to the top of stack 

								/* Storing the required registers at the specified the offsets from fp
								  in the higher memory i.e positively growing addresses */ 
		str	x19, [fp, x19_s]
		str	x20, [fp, x20_s]
		str	x21, [fp, x21_s]
		str	x22, [fp, x22_s]
		str	x23, [fp, x23_s]
		str	x24, [fp, x24_s]
		str	d8,  [fp, d8_s ]
		str	d9,  [fp, d9_s ]
		str	d10, [fp, d10_s]
		str	d11, [fp, d11_s]
			
		mov	w21, 0					// i counter 
		mov	w22, 0					// j counter 
		mov	x19, x0					// array base passed as an argument 
		mov	x20, x1					// N passed as an argument
		fmov	d9, d0					// score passed as an argument
		fmov	d10, d1					// time remaining passed as an argument 
		
		adrp	x0, newLine				/*Printing a new line character*/
		add	x0, x0, :lo12:newLine
		bl	printf
		
		b	dg_outLoopTest				// branch to dg_outLoopTest

dg_loopBody:	mul	w23, w21, w20				// w23 = i * N
		add	w23, w23, w22				// w23 = (i*N)+ j
		lsl	w23, w23, 3				// w23 = ((i*N)+j)*8
		mov	x24, -1												
		SXTW	x23, w23
		mul	x23, x23, x24				// negating x23 because array is stored in lower memory address than fp 
		ldr	d8,[x19, x23]				// loading the array element to d8
		
		adr	x1, twenty				// passing the address of pseudo op twenty to x1
		ldr	d11, [x1]				// load the value of twenty to d11 , d11 = 20.00
		fneg	d11, d11				// negating 20.00 = -20.00
		fcmp	d8, d11					// if d8 == -20.00
		b.eq	bomb					// branch to bomb 
		b.ne	dg_decide1				// else go to bg_decide1

bomb:		adrp	x0, bombSign				// pass the address of bombSign string to x0
		add	x0, x0, :lo12:bombSign
		bl	printf					// print : ' - '
		b	dg_loopBack				// branch to dg_loopBack

dg_decide1:	adr	x1, twenty				// passing the address of pseudo op twenty to x1																			
		ldr	d11, [x1]				// load the value of twenty to d11 , d11 = 20.00
		fcmp	d8, d11					// if d8 == 20.00
		b.eq	reward					// branch to reward 
		b.ne	dg_decide2				// if not equal, branch to dg_decide2

reward:		adrp	x0, rewardSign				// pass the address of rewardSign string to x0 for printing 
		add	x0, x0, :lo12:rewardSign
		bl	printf					// print: ' + '
		b	dg_loopBack				// branch to dg_loopBack

dg_decide2:	adr	x1, twentyOne				// passing the address of pseudo op twentyOne to x1
		ldr	d11, [x1]				// load the value to d11, d11 = 21.00
		fneg	d11, d11				// negate d11: d11 = -d11
		fcmp	d8, d11					// if d8 == -21.00
		b.eq	badSurp					// branch to badSurp
		b.ne	dg_decide3				// if not equal branch to dg_decide3

badSurp:	adrp	x0, badSurpSign				// passing the address of string badSurpSign to x0
		add	x0, x0, :lo12:badSurpSign
		bl	printf					// print ' ! '
		b	dg_loopBack				// branch to dg_loopBack

dg_decide3:	adr	x1, twentyOne				// passing the address of pseudo op twentyOne to x1
		ldr	d11, [x1]				// load the value to d11, d11 = 21.00
		fcmp	d8, d11					// if d8 == 21.00
		b.eq	goodSurp				// branch to goodSurp
		b.ne	dg_decide4				// if not equal, branch to dg_decide4

goodSurp:	adrp	x0, goodSurpSign			// passing the address of string goodSurpSign to x0
		add	x0, x0, :lo12:goodSurpSign
		bl	printf					// print ' $ '
		b	dg_loopBack				// branch to dg_loopBack

dg_decide4:	adr	x1, twentyThree				// passing the address of pseudo op twentyThree to x1
		ldr	d11, [x1]				// load the value to d11, d11 = 23.00
		fcmp	d8, d11					// if d8 == 23.00
		b.eq	timePack				// branch to timePack
		b.ne	printX					// if not equal branch to printX

timePack:	adrp	x0, timePackSign			//  passing the address of string timePackSign to x0
		add	x0, x0, :lo12:timePackSign
		bl	printf					// print @
		b	dg_loopBack				// branch to dg_loopBack

printX:		adrp	x0, undiscovered			// passing the address of string undiscovered to x0
		add	x0, x0, :lo12:undiscovered
		bl	printf					// print X
		b	dg_loopBack				// branch to dg_loopBack

dg_loopBack:	add	w22, w22, 1				// j = j + 1
		b	dg_inLoopTest				// branch to dg_inLoopTest
		
	
dg_inLoopTest:	cmp	w22, w20				// if j<N
		b.lt	dg_loopBody				// branch to dg_loopBody
		b.ge	dg_incrementI				// if greater than equal to, branch to dg_incrementI

dg_incrementI:	add	w21, w21, 1				// i = i + 1
		adrp	x0, newLine				// print a newLine
		add	x0, x0, :lo12:newLine
		bl	printf
		mov	w22, 0					// j= 0
		b.ge	dg_outLoopTest				// branch to dg_outLoopTest

dg_outLoopTest:	cmp	w21, w20				// if i< N
		b.lt	dg_inLoopTest				// branch to dg_inLoopTest
		b.ge	dg_continue				// if greater than equal, branch to dg_continue

dg_continue:	adrp	x0, newLine				// branch new Line
		add	x0, x0, :lo12:newLine
		bl	printf
		
		fmov	d0, d9					// pass score to d0
		adrp	x0, scoreString				// store the address of scoreString in x0
		add	x0, x0, :lo12:scoreString
		bl	printf					// print the score

		fmov	d0, d10					// pass the time remaining to d0
		adrp	x0, timeString
		add	x0, x0, :lo12:timeString
		bl	printf					// print the remaining time

dg_done:	ldr	x19, [fp, x19_s]			/*Loading the registers used back to their respective offsets in memory*/
		ldr	x20, [fp, x20_s]
		ldr	x21, [fp, x21_s]
		ldr	x22, [fp, x22_s]
		ldr	x23, [fp, x23_s]
		ldr	x24, [fp, x24_s]
		ldr	d8,  [fp, d8_s ]
		ldr	d9,  [fp, d9_s ]
		ldr	d10, [fp, d10_s]
		ldr	d11, [fp, d11_s]

		ldp	fp, lr, [sp], dg_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code



//---------C H E C K  B O A R D--------------			// This function checks if all the cells in the board have been discovered

checkBoard:	stp	fp, lr, [sp, ch_alloc]!			// allocating memory for checkBoard on the stack
		mov	fp, sp					// updating fp to point to top of the stack 
		
								/* Storing the required registers at the specified the offsets from fp
								in the higher memory i.e positively growing addresses */
		str	x19,[fp, x19_s]
		str	x20,[fp, x20_s]
		str	x21,[fp, x21_s]
		str	x22,[fp, x22_s]
		str	x23,[fp, x23_s]
		str	x24,[fp, x24_s]
		str	x25,[fp, x25_s]
		str	x26,[fp, x26_s]
		str	x27,[fp, x27_s]
		str	d8, [fp, d8_s ]
		str	d9, [fp, d9_s ]
		str	d10,[fp, d10_s]

		mov	x19, x0					// table base address
		mov	x20, x1					// N
		mov	w21, 0					// i counter 
		mov	w22, 0					// j counter 
		mov	w23, 0					// count
		mov	w24, 0					// allDiscovered
		mov	w25, 0					// offset for array elements	
		mov	x26, 0
		mov	x27, 0
		b	ch_outLoopTest				// branch to ch_outLoopTest
	
ch_loopBody:	mul	w25, w21, w20				// w25 = i*N
		add	w25, w25, w22				// w25 = (i*N)+j
		lsl	w25, w25, 3				// w25 = ((i*N)+j)*8
		mov	x26, -1
		SXTW	x25, w25
		mul	x25, x25, x26				// negating x25 because the element is stored in lower memory address
		ldr	d8,[x19, x25]				// laod the element in d8

		adr	x1, twenty				// store the address of pseudo op twenty in x1
		ldr	d9,[x1]					// loading 20.00 in d9
		fcmp	d8, d9					// if d8 == 20.00
		b.eq	countPlus				// branch to countPlus
		b.ne	ch_ifNegTwenty				// if not equal then branch to ch_ifNegtwenty

ch_ifNegTwenty:	adr	x1, twenty				// store the address of pseudo op twenty in x1
		ldr	d9, [x1]				// loading 20.00 in d9
		fneg	d9, d9					// d9 = -20.00
		fcmp	d8, d9					// if d8 == -20.00
		b.eq	countPlus				// branch to countPlus
		b.ne	ch_ifTwentyOne				// if not equal branch to ch_ifTwentyOne
		
ch_ifTwentyOne:	adr	x1, twentyOne				// store the address of pseudo op twentyOne in x1
		ldr	d9, [x1]				// loading 21.00 in d9
		fcmp	d8, d9					// if d8 == 21.00
		b.eq	countPlus				// branch to countPlus
		b.ne	ch_ifNegTwentyOne			// if not equal then branch to ch_ifNegTwentyOne

ch_ifNegTwentyOne: adr    x1, twentyOne				// store the address of pseudo op twentyOne in x1
		   ldr	  d9, [x1]				// loading 21.00 in d9
		   fneg	  d9, d9				// d9 = -21.00
		   fcmp	  d8, d9				// if d8 == -21.00
		   b.eq   countPlus				// branch to countPlus
		   b.ne	  ch_ifTwentyThree			// if not equal branch to ch_ifTwentyThree

ch_ifTwentyThree:  adr	  x1, twentyThree			// store the address of pseudo op twentyThree in x1
		   ldr	  d9, [x1]				// loading 23.00 in d9
		   fcmp	  d8, d9				// if d8 == 23.00
		   b.eq   countPlus				// branch to countPlus
		   add	  w22, w22, 1				// j = j+ 1
		   b.ne	  ch_inLoopTest				// if not equal, branch to ch_inLoopTest

countPlus:	add	w23, w23, 1				// count+=1
		add	w22, w22, 1				// j = j+1
		b	ch_inLoopTest				// branch to ch_inLoopTest

ch_inLoopTest:	cmp	w22, w20				// if j<N
		b.lt	ch_loopBody				// branch to loopBody
		b.ge	ch_incrementI				// if greater than equal to, branch to ch_incrementI

ch_incrementI:	add	w21, w21, 1				// i = i+ 1
		mov	w22, 0					// j = 0
		b.ge	ch_outLoopTest				// branch to ch_outLoopTest

ch_outLoopTest:	cmp	w21, w20				// if i<N
		b.lt	ch_inLoopTest				// branch to ch_inLoopTest
		b.ge	ch_continue				// if greater than or equal to, branch to ch_continue

ch_continue:	mul	w27, w20, w20				// w27 = N * N 
		cmp	w27, w23				// if w27 == counti.e all the cells have been visited
		b.eq	ch_setTrue				// branch to ch_setTrue
		b.ne	ch_return				// if not equal, branch to ch_return

ch_setTrue:	mov	w24, 1					// w24 = 1
		SXTW	x24, w24																				
		mov	x0, x24					// setting x0 as w24 for returning 
		b	ch_done					// branch to ch_done
 
ch_return:	SXTW	x24, w24
		mov	x24, 0					// assign x24 the value in x24
		mov	x0, x24					// set the return value
		b	ch_done					// branch to ch_done

ch_done:	ldr	x19,[fp, x19_s]				/*Loading the registers used back to their respective offsets in memory*/
		ldr	x20,[fp, x20_s]
		ldr	x21,[fp, x21_s]
		ldr	x22,[fp, x22_s]	
		ldr	x23,[fp, x23_s]
		ldr	x24,[fp, x24_s]
		ldr	x25,[fp, x25_s]
		ldr	x26,[fp, x26_s]
		ldr	x27,[fp, x27_s]
		ldr	d8, [fp, d8_s ]
		ldr	d9, [fp, d9_s ]
		ldr	d10,[fp, d10_s] 
		ldp	fp, lr, [sp], ch_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code




//----------R A N D O M N U M----------------			/* This fucntion generates a randum number between 0 and 15 using bitwise AND*/

randomNum:	stp	fp, lr, [sp, r_alloc]!			// allocating memory for randomNum on the stack
		mov	fp, sp					// update fp to point to teh top of the stack 
	
		fmov	d0, d0					// 0.0, passed as an argument to this funtion
		fmov	d1, d1					// 14.00 passed as an argument to this function
		mov	w0, w0					// neg, 1 if true 0 if false, also an argument 

		str	d0, [fp, randMin_s  ]			// store 0.0 on the stack 
		str	d1, [fp, randMax_s  ]			// store 14.00 on stack 
		str	w0, [fp, neg_s	    ]
		
		adr	x1, zero				// x1 contains address to zero 
		
		ldr	d3, [x1]				// load 0.0 in d3
		str	d3, [fp, randfloat_s]			// store 0.0 at randfloat_s
		
		ldr	d4, [x1]				// load 0.0 in d4
		str	d4, [fp, scale_s    ]			// store 0.0 at scale_s

		ldr	d5, [x1]				// load 0.0 in d4
		str	d5, [fp, rand_s	    ]			// store 0.0 at scale_s

		bl	rand					// call rand
		mov	x2, x0					// x2 has random numuber
		
								/* Load back the values from the stack 
								 to make sure calling rand has no change on 
								 values of any register except x0*/
		ldr	d0, [fp, randMin_s  ]
		ldr	d1, [fp, randMax_s  ]
		ldr	w0, [fp, neg_s      ]
		ldr	d3, [fp, randfloat_s]
		ldr	d4, [fp, scale_s    ]
		ldr	d5, [fp, rand_s	    ]
	
		fcvtns	x3, d1					// x3 has 14
		
		and	x4, x2, x3				// rand & int max	- using bitwise AND to get a random number between 0 and 15, 0 exclusive		
		scvtf	d3, x4					// float randfloat = rand & int max
		
		str	d3, [fp, randfloat_s]			// store the randfloat on stack before calling rand again
		
		bl	rand					// call rand
		mov	x8, x0					// store random number in x8

								/* Load back the values from the stack 
								to make sure calling rand has no change on 
								 values of any register except x0*/
		ldr	w0, [fp, neg_s      ]
		ldr	d3, [fp, randfloat_s]
		ldr	d4, [fp, scale_s    ]

		mov	x4, 0
		mov	x5, 0x64				// x5 stores 100
		mov	x6, 0
		udiv	x4, x8, x5				// taking udiv of random number and 100
		msub	x7, x4, x5, x8				// performing msub to get a number between 0 and 100
																				
		scvtf	d4, x7					// convert teh random number to float
								// d4 is now scale
		adr	x1, hundred				// x1 has the address of hundred
		ldr	d7, [x1]				// d7 = 100.00
		ldr	w1, [fp, neg_s	    ]			// loading Neg into w1

		fdiv	d4, d4, d7				// divide scale by 100 to get a float of the form 0.xy
		
		fadd	d3, d3, d4				// add the float from previous step to random number to get a float between 0 and 15, 0 exclusive

		cmp	w0, 1					// if neg == 1
		b.eq	r_negate				// branch to negate
		cmp	w0, 0					// if neg == 0
		b.eq	r_continue				// branch to r_continue

r_negate:	fneg	d3, d3					// negate the random float
		b	r_continue			

r_continue:	fmov	d0, d3					// return the random float

		ldp	fp, lr, [sp], r_dealloc			// deallocating memory : load fp and lr back to original values
		ret						// return to calling code




/*----------INITIALIZE_GAME-------------------*/		/* This function takes in table base address and N as input and
								  initializes random floats to each cell on the board*/

initializeGame:	stp	fp, lr, [sp, i_alloc]!			// allocating memory for initializeGame on the stack
		mov	fp, sp					// update fp to point to the top of stack

								/* Storing the required registers at the specified the offsets from fp
								in the higher memory i.e positively growing addresses */
		str	x19,[fp, x19_s]
		str	x20,[fp, x20_s]
		str	x21,[fp, x21_s]
		str	x22,[fp, x22_s]
		str	x23,[fp, x23_s]
		str	x24,[fp, x24_s]
		str	x25,[fp, x25_s]
		str	x26,[fp, x26_s]
		str	d8, [fp,  d8_s]
		str	d9, [fp,  d9_s]
		str	d10,[fp, d10_s]
		str	d11,[fp, d11_s]
		str	d12,[fp, d12_s]

		mov	x19, x0					// table base address
		mov	x20, x1					// N

		mul	x21, x20, x20				// x21 = N*N
		scvtf	d8, x21					// d8 = float totalCells = N*N 
		adr	x21, zero				// store address of zero in x21
		ldr	d9,[x21]				// d9 = totalNegCells = 0.0
		
		mov	w21, 0					// i
		mov	w22, 0					// j
		mov	w23, 2					// rand generates either 0 or 1	
		
		mov	w10, 0					// udiv_s
		mov	w11, 0					// msub_s
		
		str	w10,[fp, udiv_s]			// store w10 and w11 on the stack
		str	w11,[fp, msub_s]

		b	i_outLoopTest				// branch to i_outLoopTest

i_loopBody:	bl	rand					// call rand
		mov	w9, w0					// store random number in w9
		ldr	w10,[fp, udiv_s]			// load back w10 and w11 
		ldr	w11,[fp, msub_s]
		udiv	w10, w9, w23				// generating a random number, either 0 or 1
		msub	w11, w10, w23, w9			//w11 has either 1 or 0
		
		cmp	w11, 0					// comparing w11 to 0
		b.eq	randBitZero				// if equal, then brannch to randBitZero
		cmp	w11, 1					// comparing w11 to 1
		b.eq	randBitOne				// branch to randBitOne if equal
		
randBitZero:	add	w24, w24, 1				// neg = true
		fmov	d1, 1.0
		fadd	d9, d9, d1				// total Negative Cells += 1 
		
		fdiv	d2, d9, d8				// d2 = totalNegCells/totalCells
		adr	x1, pointTwo																					
		ldr	d19,[x1]				// d19 = 0.20
		fmov	d3, d19					// d3 = 0.20
		fcmp	d2, d3					// compare totalNegCells/totalCells to 0.20
		b.gt	negFalse				// if greater than, branch to negFalse
		fcmp	d2, d3					// compare totalNegCells/totalCells to 0.20
		b.lt	i_continue				// if less than, branch to i_continue

negFalse:	mov	w24, 0					// set w24 to 0 and branch to i_continue
		b	i_continue
		
randBitOne:	mov	w24, 0					// set w24 to 0 and branch to i_continue
		b	i_continue
																							
								// passing arguments to randomNum
i_continue:	adr	x1, zero				// set d0 to 0.0
		ldr	d0, [x1]
		fmov	d1, 14.00 				// set d1 to 14.00
		mov	w0, w24					// set w0 to the value of neg ( 0 or 1 )
		bl	randomNum				// call randomNum
		fmov	d10, d0					// store the returned float into d10 

		mul	w25, w21, w20				// w25 = i*N
		add	w25, w25, w22				// w25 = (i*N)+ j
		lsl	w25, w25, 3				// w25 = ((i*N)+j)* 8
		mov	x26, -1	
		SXTW	x25, w25
		mul	x25, x25, x26				// negate x25
		
		str	d10,[x19, x25]				// store random float in the array
		add	w22, w22, 1				// j = j+ 1
		b	i_inLoopTest				// branch to i_inLoopTest

i_inLoopTest:	cmp	w22, w20				// compare i , N
		b.lt	i_loopBody				// if i<N, branch to i_loopBody, 
		b.ge	i_incrementI				// if i>=N, branch to i_incrementI

i_incrementI:	add	w21, w21, 1				// i = i + 1
		mov	w22, 0					// j = 0
		b.ge	i_outLoopTest				// branch to q_outLoopTest

i_outLoopTest:	cmp	w21, w20				// compare i,N
		b.lt 	i_inLoopTest				// if i<N, branch to i_inLoopTest
		b.ge	i_done					// if i>=N, branch to i_done
		
i_done:		ldr	x19,[fp, x19_s]				/*Loading the registers used back to their respective offsets in memory*/
		ldr	x20,[fp, x20_s]
		ldr	x21,[fp, x21_s]
		ldr	x22,[fp, x22_s]
		ldr	x23,[fp, x23_s]
		ldr	x24,[fp, x24_s]
		ldr	x25,[fp, x25_s]
		ldr	x26,[fp, x26_s]
		ldr	d8, [fp,  d8_s]
		ldr	d9, [fp,  d9_s]
		ldr	d10,[fp, d10_s]
		ldr	d11,[fp, d11_s]
		ldr	d12,[fp, d12_s]
	
		ldp	x29, x30, [sp], i_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code


//---------T I M E B O N U S---------------			/*This function decides whether or not a time pack bonus will be given using Bitwise AND*/


timeBonus:	stp	x29, x30, [sp, ti_alloc]!		// allocating memory for timeBonus on the stack
		mov	x29, sp					// update fp to point to the top of stack
								/* Storing the required registers at the specified the offsets from fp
								  in the higher memory i.e positively growing addresses */

		str	x19,[fp, x19_s]
		str	x20,[fp, x20_s]
		str	x21,[fp, x21_s]
		str	x22,[fp, x22_s]
		str	x23,[fp, x23_s]	
		str	x24,[fp, x24_s]
		str	x25,[fp, x25_s]
		str	x26,[fp, x26_s]
		str	x27,[fp, x27_s]
		str	x28,[fp, x28_s]
		str	d8, [fp, d8_s ]
		str	d9, [fp, d9_s ]
		str	d10,[fp, d10_s]
		str	d11,[fp, d11_s]
		str	d12,[fp, d12_s]
		str	d13,[fp, d13_s]
		str	d14,[fp, d14_s]
		str	d15,[fp, d15_s]		

		mov	x19, x0					// table base address
		mov	w20, w1					// i Coord
		mov	w21, w2					// j Coord
		mov	x22, x3					// N
		fmov	d8, d0					// time rem
		mov	x23, x4					// surpCount : a pointer to surprise_count
		fmov	d9, d1					// total_surprises

		mul	w25, w20, w22				// i*N
		add	w25, w25, w21				// (i*N)+j
		lsl	w25, w25, 3				// ((i*N)+j)*8
		mov	x28, -1
		SXTW	x25, w25
		mul	x25, x25, x28				// negate x25

		ldr	d10, [x19, x25]				// load the cellValue to d10															
		
		bl	rand					// call rand
		mov	x1, 0xB					// x1 = 11
		and	x26, x0, x1				// bitwise and of x0 and x1, result in x26, a random int between 0 and 10
		
 		b	ti_ifNegTwenty				// branch to ti_ifNegTwenty

ti_ifNegTwenty:	adr	x1, twenty				// load 20.00 into d11
		ldr	d11, [x1]
		fneg	d11, d11				// d11 = -20.00
		fcmp	d10, d11				// compare d10, d11
		b.eq	ti_discovered				// if equal, branch to ti_discovered
		b.ne	ti_ifTwenty				// if not equal, branch to ti_ifTwenty

ti_ifTwenty:	adr	x1, twenty				// load 20.00 into d11
		ldr	d11, [x1]				// d11 = 20.00
		fcmp	d10, d11				// compare d10, d11
		b.eq	ti_discovered				// if equal, branch to ti_discovered
		b.ne	ti_ifNegTwentyOne			// if not equal, branch to ti_ifTwentyOne

ti_ifNegTwentyOne:	adr	x1, twentyOne			// load 21.00 into d11
			ldr	d11, [x1]
			fneg	d11, d11			// d11 = -21.00
			fcmp	d10, d11			// compare d10 to d11
			b.eq	ti_discovered			// if equal, branch to ti_discovered
			b.ne	ti_ifTwentyOne			// if not equal, branch to ti_ifTwentyOne

ti_ifTwentyOne:		adr	x1, twentyOne			// load 21.00 into d11
			ldr	d11, [x1]
			fcmp	d10, d11			// compare d10 to d11
			b.eq	ti_discovered			// if equal, branch to ti_discovered
			b.ne	ti_ifTwentyThree		// if not equal, branch to ti_ifTwentyThree

ti_ifTwentyThree:	adr	x1, twentyThree			//  load 23.00 into d11
			ldr	d11, [x1]
			fcmp	d10, d11			// compare d10 to d11
			b.eq	ti_discovered			// if equal, branch to ti_discovered
			b.ne	ti_ifBonus			// if not equal, branch to ti_ifBonus

ti_discovered:		adrp 	x0, blank			// store address of string newLine in x0
			add 	x0, x0, :lo12:blank
			bl	printf				// prinnt blank
			b	ti_done				// branch to ti_done

ti_ifBonus:		cmp	x26, 2				// compare isBonus to 2, 
			b.eq	ti_ifSurpCntVld			// if equal, we check if surprise count is less than 20% of N*N
			b.ne	ti_done				// if not , branch to ti_done

ti_ifSurpCntVld:	ldr	d12, [x23]			// load surprise count into d12 by dereferencing x23
			fcmp	d12, d9				// check if surprise count is less than 20% of N*N
			b.lt	ti_isBonus			// if true, then branch to ti_isBonus
			b	ti_done				// branch to ti_done otherwise

ti_isBonus:		adr	x1, ten																				
			ldr	d10, [x1]			// d10 = 10.00
			fadd	d8, d8, d10			// time remaining = time_remaining + 10

			adr	x1, twentyTwo																			
			ldr	d10,[x1]			// d10 = 22.00
			str	d10,[x19, x25]			// update table cell value to 22.00
		
			ldr	d7,[x23]			// load surprise count in d7
			adr	x1, one
			ldr	d6,[x1]				// d6 = 1.00
			fadd	d7, d7, d6			// surprise count += 1
			str	d7,[x23]			// store the value of surprise count using pointer 
			b	ti_done																					

ti_done:		fmov	d0, d8				// pass the return value to d0

			ldr	x19,[fp, x19_s]			/*Loading the registers used back to their respective offsets in memory*/
			ldr	x20,[fp, x20_s]
			ldr	x21,[fp, x21_s]
			ldr	x22,[fp, x22_s]
			ldr	x23,[fp, x23_s]	
			ldr	x24,[fp, x24_s]
			ldr	x25,[fp, x25_s]
			ldr	x26,[fp, x26_s]
			ldr	x27,[fp, x27_s]
			ldr	x28,[fp, x28_s]
			ldr	d8, [fp, d8_s ]
			ldr	d9, [fp, d9_s ]
			ldr	d10,[fp, d10_s]
			ldr	d11,[fp, d11_s]
			ldr	d12,[fp, d12_s]
			ldr	d13,[fp, d13_s]
			ldr	d14,[fp, d14_s]
			ldr	d15,[fp, d15_s]

			ldp	x29, x30, [sp], ti_dealloc	// deallocating memory : load fp and lr back to original values
			ret					// return to calling code




/*------------EXIT GAME-------------------*/			/*This function is called when a game over condition is met and the game is exited*/

exitGame:	stp	x29, x30, [sp, ex_alloc]!		// allocating memory for exitGame on the stack
		mov	x29, sp					// updating x29 to point to top of stack 
																										
								/* Storing the required registers at the specified the offsets from fp
								  in the higher memory i.e positively growing addresses */
		str	x19,[sp, x19_s]
		str	d8, [sp, d8_s ]
		str	d9, [sp, d9_s ]
		str	d10,[sp, d10_s]

		mov	x19, x0					// player name
		fmov	d8,  d0					// score
		fmov	d9,  d1					// time remaining
		fmov	d10, d2					// total time alloted

		mov	x1, x19					// printing the endgreet string along with player name
		adrp	x0, endgreet
		add	x0, x0, :lo12:endgreet
		bl	printf

		fmov	d0, d8					// print the score
		adrp	x0, scoreString
		add	x0, x0, :lo12:scoreString
		bl	printf

		fsub	d0, d10, d9				// calculate time taken by subtracting d9 from d10
		adrp	x0, endTime
		add	x0, x0, :lo12:endTime
		bl	printf					// print the time taken

		ldr	x19,[sp, x19_s]				/*Loading the registers used back to their respective offsets in memory*/
		ldr	d8, [sp, d8_s ]
		ldr	d9, [sp, d9_s ]
		ldr	d10,[sp, d10_s]

		ldp	x29, x30, [sp], ex_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code





/*----------T I M E_R E M------------------*/			/*This function calculates the remaning time and returns it*/

timeRem:	stp	x29, x30, [sp, t_alloc]!		// allocating memory for timeRem on the stack
		mov	x29, sp					// updating x29 to point to top of stack 
																										
								/* Storing the required registers at the specified the offsets from fp
								in the higher memory i.e positively growing addresses */
		str	x19, [fp, x19_s]
		str	x20, [fp, x20_s]
		str	x21, [fp, x21_s]
		str	d8,  [fp, d8_s ]

		mov	x19, x0					// start tiem	
		mov	x20, x1					// end time
		fmov	d8, d0					// time remaining
		fcvtns	x21, d8					// convert remaining time to int

		sub	x21, x20, x19				// time taken		
								// calculate time taken by subtracting start time from end time
		scvtf	d1, x21	
			
		fsub	d8, d8, d1				// calculate remaining time by subtracting time taken from total time
		
		fmov	d0, d8					// return remainng time
		
		ldr	x19, [fp, x19_s]			/*Loading the registers used back to their respective offsets in memory*/
		ldr	x20, [fp, x20_s]
		ldr	x21, [fp, x21_s]
		ldr	d8,  [fp, d8_s ]		
		ldp	x29, x30, [sp], t_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code




/*---------CALCULATE SCORE------------------*/			/*This function calculates the score , 
								and generates surprises using Bitwise Arithmetic . lsl and lsr ,and updates the board accordingly*/

calculateScore:	stp	x29, x30, [sp, c_alloc]!		// allocating memory for calculateScore on the stack
		mov	x29, sp					// updating x29 to point to top of stack 
		
								/* Storing the required registers at the specified the offsets from fp
								in the higher memory i.e positively growing addresses */
		str	x19,[fp, x19_s]
		str	x20,[fp, x20_s]
		str	x21,[fp, x21_s]
		str	x22,[fp, x22_s]
		str	x23,[fp, x23_s]	
		str	x24,[fp, x24_s]
		str	x25,[fp, x25_s]
		str	x26,[fp, x26_s]
		str	x27,[fp, x27_s]
		str	x28,[fp, x28_s]
		str	d8, [fp, d8_s ]
		str	d9, [fp, d9_s ]
		str	d10,[fp, d10_s]
		str	d11,[fp, d11_s]
		str	d12,[fp, d12_s]
		str	d13,[fp, d13_s]
		str	d14,[fp, d14_s]
		str	d15,[fp, d15_s]		

		fmov	d8, d0					// current score
		mov	x19, x0					// table base
		mov	w20, w1					// iCoord
		mov	w21, w2					// jCoord
		mov	x22, x3					// N
		mov	x24, x4					// surpCount
		fmov	d9, d1					// total_surprises

		mul	w25, w20, w22				// w25 = i*N
		add	w25, w25, w21				// w25 = (i*N)+ j
		lsl	w25, w25, 3				// w25 = ((i*N)+j)*8
		mov	x28, -1																						
		SXTW	x25, w25	
		mul	x25, x25, x28				// negate the offset														

		ldr	d10, [x19, x25]				// load cellValue in d10
		
		bl	rand					// call rand
		mov	x1, 0xB
		and	x26, x0, x1				// isSurprise = a value between 0 and 10
 		b	ifNegTwenty				// branch to ifNegTwenty

ifNegTwenty:	adr	x1, twenty
		ldr	d11, [x1]				// load 20.00 in d11
		fneg	d11, d11				// negate d11
		fcmp	d10, d11				// d10 = -20.00
		b.eq	c_discovered				// compare d10, d11, if equal the cell has been discovered, branch to c_discovered
		b.ne	ifTwenty				// if not equal branch to ifTwenty

ifTwenty:	adr	x1, twenty
		ldr	d11, [x1]				// laod 20.00 in d11
		fcmp	d10, d11				// compare d10,d11
		b.eq	c_discovered				// if equal branch to c_discovered
		b.ne	ifNegTwentyOne				// if not, branch to ifNegTwentyOne

ifNegTwentyOne:	adr	x1, twentyOne																			
		ldr	d11, [x1]				// d11 = 21.00
		fneg	d11, d11				// d11 = -21.00
		fcmp	d10, d11				// if equal branch to c_discovered
		b.eq	c_discovered
		b.ne	ifTwentyOne				// if not, branch to ifTwentyOne

ifTwentyOne:	adr	x1, twentyOne
		ldr	d11, [x1]				// d11 = 21.00
		fcmp	d10, d11				// compare d10, d11
		b.eq	c_discovered				// if equal, branch to c_discovered
		b.ne	ifTwentyThree				// if not, branch to ifTwentyThree

ifTwentyThree:	adr	x1, twentyThree															
		ldr	d11, [x1]				// d11  = 23.00
		fcmp	d10, d11				// compare d10 and d11
		b.eq	c_discovered				// if equal, branch to c_discovered
		b.ne	ifTwentyTwo				// if not , branch to ifTwentyTwo

c_discovered:	adrp 	x0, cellDiscovered
		add 	x0, x0, :lo12:cellDiscovered
		bl	printf					// if cell discovered, print the cellDiscovered string
		b	c_done

ifTwentyTwo:	adr	x1, twentyTwo																			
		ldr	d11, [x1]				// d11 = 22.00
		fcmp	d10, d11				// if d10 == d11
		b.eq	isTwentyTwo				// branch to isTwentyTwo
		b.ne	ifCVPos					// if not, branch to ifCVPos

isTwentyTwo:	adrp	x0, timePackString			// print the timePack string
		add	x0, x0, :lo12:timePackString
		bl	printf
		
		adr	x1, twentyThree
		ldr	d11,[x1]				// d11 = 23.00
		fmov	d10, d11
		str	d10,[x19, x25]				// update d10 on the table
		b	c_done					// branch to c_done

ifCVPos:	adr	x1, zero	
		ldr	d11, [x1]				// d11 = 0.0
		fcmp	d10, d11				// if d10 > 0.0
		b.gt	ifSurprise				// branch to ifSurprise
		b.lt	ifCVNeg					// if d10 < 0.0 , branch to ifCVNeg

ifSurprise:	cmp	x26, 1					// if x26, is 1, check if surprise count is valid
		b.eq	ifSurpCntVld
		b.ne	c_reward

ifSurpCntVld:	ldr	d12, [x24]				// load surprise count value by dereferencing x24
		fcmp	d12, d9
		b.lt	isSurprise				// if it is < 0.2, bracnh to isSurprise, otherwise branch to reward
		b	c_reward

isSurprise:	adrp	x0, niceSurpString
		add	x0, x0, :lo12:niceSurpString		// print nice surprise string 
		bl	printf
		mov	x1, 0
	
		adr	x2, hundred
		ldr	d7, [x2]				// d7 = 100.0
		fmul	d8, d8, d7				// multipply cellvalue by 100.00
		fcvtns	x1, d8					// convert to int
		lsl	x1, x1, 1				// logial shift left to double the value
		scvtf	d8, x1					// convert back to float 
		fdiv	d8, d8, d7
		adr	x1, twentyOne
		ldr	d10,[x1]																	
		str	d10,[x19, x25]				// update the cellvalue to 21.00
		
		ldr	d7,[x24]				// load the surprise count value in d7 and add 1 to it
		adr	x1, one
		ldr	d6,[x1]
		fadd	d7, d7, d6																							
		str	d7,[x24]				// store back using pointer
		b	c_done

c_reward:	fmov	d0, d10																									
		adrp	x0, rewardString
		add	x0, x0, :lo12:rewardString
		bl	printf					// print the reward string
		
		fadd	d8, d8, d10				// add the cell value to score
		adr	x1, twenty
		ldr	d10, [x1]																									
		str	d10,[x19, x25]				// update the cell value to 20.00
		b	c_done

ifCVNeg:	adr	x1, zero																					
		ldr	d11, [x1]				// d11 = 0.0
		fcmp	d10, d11				// compare d10 and d11
		b.lt	ifBadSurprise				// if d10<0.0 , check ifBadSurprise
		
ifBadSurprise:	cmp	x26, 1					// if x26 == 1
		b.eq	ifSurpCntVld_2				// check if surprise count value is < 0.2 of N*N
		b.ne	c_bomb					// if not branch to c_bomb

ifSurpCntVld_2: ldr	d12, [x24]
		fcmp	d12, d9					// d12 = surprise count value
		b.lt	isBadSurprise				// if surprise count <0.2 of N*N
		b	c_bomb					// branch to c_bomb

isBadSurprise:	mov	x1, 0																		
		adrp	x0, badSurpString
		add	x0, x0, :lo12:badSurpString																	
		bl	printf					// print bad surprise string

		adr	x2, hundred
		ldr	d7, [x2]
		fmul	d8, d8, d7				// multiply score by 100
		fcvtns	x1, d8
		lsr	x1, x1, 1				// logical shift right 1 to divide by 2 
		scvtf	d8, x1
		fdiv	d8, d8, d7				// divide by 100
		adr	x1, twentyOne
		ldr	d10, [x1]																						
		fneg	d10, d10
		str	d10,[x19, x25]				// upfate the cell value to -21.00

		ldr	d7, [x24]				// load the surprise count value
		adr	x1, one
		ldr	d6, [x1]
		fadd	d7, d7, d6				// add 1 to surprise count and store it back using pointer surpCount
		str	d7,[x24]
		b	c_done

c_bomb:		fmov	d0, d10
		adrp	x0, bombString
		add	x0, x0,:lo12:bombString
		bl	printf					// print the bombstring
		
		fadd	d8, d8, d10				// add the negative value to score
		adr	x1, twenty
		ldr	d10, [x1]
		fneg	d10, d10				// update the cell value to -20.00
		str	d10, [x19, x25]																					
		b	c_done

c_done:		fmov	d0, d8					// pass the score to d0 for returning 
								/*Loading the registers used back to their respective offsets in memory*/
		ldr	x19,[fp, x19_s]
		ldr	x20,[fp, x20_s]
		ldr	x21,[fp, x21_s]
		ldr	x22,[fp, x22_s]
		ldr	x23,[fp, x23_s]	
		ldr	x24,[fp, x24_s]
		ldr	x25,[fp, x25_s]
		ldr	x26,[fp, x26_s]
		ldr	x27,[fp, x27_s]
		ldr	x28,[fp, x28_s]
		ldr	d8, [fp, d8_s ]
		ldr	d9, [fp, d9_s ]
		ldr	d10,[fp, d10_s]
		ldr	d11,[fp, d11_s]
		ldr	d12,[fp, d12_s]
		ldr	d13,[fp, d13_s]
		ldr	d14,[fp, d14_s]
		ldr	d15,[fp, d15_s]

		ldp	x29, x30, [sp], c_dealloc		// deallocating memory : load fp and lr back to original values
		ret						// return to calling code


//--------------MAIN------------------------
main:		stp 	x29, x30, [sp, m_alloc]!
		mov 	x29, sp
		
		mov	x19, x0					// moving argc to x19
		mov	x20, x1					// moving base address of argv to x20
		
		b	errCheck1				// brach to errCheck1

errCheck1:	cmp	x19, 3					// compare argc to 3
		b.lt	invalidArgs				// if argc<3, bracnh to invalidArgs
		b.gt	invalidArgs				// if argc>3 branch to invalidArgs
		b.eq	argsOk					// else branch to argsOk

invalidArgs:	adrp	x0, err1
		add	x0, x0, :lo12:err1
		bl	printf
		b	done

argsOk:		mov	w9, 1					// index of player name
		mov	w10,2					// index of board dimensions
		ldr	x21,[x20, w9, SXTW 3]			// loading player name in x21
		ldr	x22,[x20, w10,SXTW 3] 			// loading dimensions to  x22

		mov	x0, x22					// passing dimension to x0 as argument for atoi
		bl	atoi					// calling atoi
		mov	x22, x0					// x22 now has dimensions as an integer

		b	dimCheck				// if correct no. of arguments passed, branch to dimCheck

dimCheck:	cmp	x22, 5					// if dimensions less than 5, branch to invalidDimL
		b.lt	invalidDimL
		cmp	x22, 20					// if dimensions greater than 20, branch to invalidDimG
		b.gt	invalidDimG
		b	dimOk					// else, bracnh to dimOk
						
invalidDimL:	adrp	x0, err2				// pass address of err2 to x0
		add	x0, x0, :lo12:err2			// store err2 in lower 12 bits of x0
		bl	printf					// call printf
		b	done					// bracnh to done

invalidDimG:	adrp	x0, err3				// pass address of err3 to x0
		add	x0, x0, :lo12:err3			// store err3 in lower 12 bits of x0
		bl	printf					// call printf
		b	done					// branch to done
		
dimOk:		adrp	x0, greeting				// store address of greeting string in x0 
		add	x0, x0, :lo12:greeting			// store greeting in lower 12 bits of x0
		mov	x1, x21					// pass player name to x1
		mov	x2, x22
		bl	printf					// call printf
		b	m_continue

m_continue:	mov	x19, x22				// storing N in x19
		mov	x20, x21				// storing playerName in x20
		
		add	sp, sp, -allocateMem & -16		// allocating memory on stack for table & other variables
		
		mov	x0, 0
		bl	time
		bl	srand
		
		sub	x0, fp, table_s				// passing base address to initializeGame using x0
		mov	x1, x19					// passing N using x1
		bl	initializeGame
		
		sub	x0, fp, table_s				// passing base address of array to x0 
		mov	x1, x19					// passing N to x1
		bl	display					// call display 
	
		adr	x1, zero
		ldr	d10, [x1]
		
		mov	x21, 0
		str	x21, [fp, response_s]			// response = 0

		mov	x22, 0				
		str	x22, [fp, firstMove_s]			// initial move if firstMove = 0

		adr	x1, twelve
		ldr	d1,[x1]

		scvtf	d2, x19
		fmul	d8, d1, d2				// time_rem = N*12.00
		
		fmov	d9, d8					// total_time = time_rem
	
		mov	x26, 0					// allDiscovered = 0

		sub	x0, fp, table_s				// pass the table base address to x0 
		mov	x1, x19					// pass N to x1
		fmov	d0, d10					// pass score to d0
		fmov	d1, d8					// pass the remaining time
		
		bl	displayGame				// call displayGame
		
		adr	x1, zero
		ldr	d1,[x1]
								// calculating total surprises
		scvtf	d1, x19
		fmul	d1, d1, d1
		adr	x1, pointTwelve
		ldr	d2, [x1]
		fmul	d11, d2, d1				// total_surprises will always be 0.12*N*N ( 3 surprises if N = 5)

		adr	x1, zero
		ldr	d12, [x1]				// surprise count
		str	d12, [fp, surpriseCount_s]
		
		mov	x0, 0
		add	x0, fp, surpriseCount_s
		mov	x23, x0					// surpCount : pointer to surpriseCount			

			
m_loopBack:	adrp	x0, movePrompt
		add	x0, x0, :lo12:movePrompt
		bl	printf
		
		mov	x0, 0
		bl	time
		mov	x27, x0					// start time

m_in:		adrp	x0, inputMove
		add	x0, x0, :lo12:inputMove
		adr	x1, i_coord
		adr	x2, j_coord
		bl	scanf					// user enters i and j

		adr	x1,i_coord
		adr	x2,j_coord
		ldr	w24,[x1]				// loading i into w24
		ldr	w25,[x2]				// loading j into w25

validatei_1:	cmp	w24, 0					// if i < 0 , input is invalid, prompt the user again
		b.lt	invalid
		b.ge	validatei_2

invalid:	adrp	x0, err4
		add	x0, x0, :lo12:err4
		bl	printf					// print err4 string 
		b	m_in

validatei_2:	sub	w1, w19, 1				// if i > (N-1), input is invalid, prompt the user again
		cmp	w24, w1
		b.gt	invalid
		b.lt	validatej_1

validatej_1:	cmp	w25, 0					// if j< 0, input is invalid , prompt the user again
		b.lt	invalid
		b.ge	validatej_2

validatej_2:	sub	w1, w19, 1				// if j > (N-1), input is invalid, prompt the user again
		cmp	w25, w1
		b.gt	invalid
		b.lt	inputValid

inputValid:	mov	x0, 0
		bl	time
		mov	x28, x0					// end time

		mov	x0, x27					// pass the start time to x0
		mov	x1, x28					// pass the end time to x1
		fmov	d0, d8					// pass the remaining time to d0
		bl	timeRem					// call timeRem
		fmov	d8, d0					// updated remaining time
		
		adr	x1, zero
		ldr	d1, [x1]

		fcmp	d8, d1					// if time remaning < 0, branch to timeUp, otherwise to timenotUp
		b.le	timeUp
		b.gt	timenotUp		

timeUp:		adrp	x0, gameOver1
		add	x0, x0, :lo12:gameOver1			// print gameover1 string and branch to m_break to call exitGame
		bl	printf
		b	m_break

timenotUp:	sub	x0, fp, table_s				// pass the table base address to x0
		mov	w1, w24					// i 
		mov	w2, w25					// j
		mov	x3, x19					// N
		fmov	d0, d8					// time remaining 
		mov	x4, x23					// surpCount : a pointer to surprise count
		fmov	d1, d11					// total surprises
		bl	timeBonus				// call timeBonus
		fmov	d8, d0					// return the updated time to d8
		
		fmov	d0, d10					// score
		sub	x0, fp, table_s				// table base address
		mov	w1, w24					// i
		mov	w2, w25					// j
		mov	x3, x19					// N
		mov	x4, x23					// surpCount
		fmov	d1, d11					// totalSurprises
		bl	calculateScore				// call calculate score
		fmov	d10, d0					// update score returned in d10
	
		sub	x0, fp, table_s				// table base address
		mov	x1, x19					// N
		fmov	d0, d10					// score
		fmov	d1, d8					// time remaining
		bl	displayGame				// call displayGame
	
		cmp	x22, 1					// if not firstMove, scoreValidate, otherwise, scorenotLow
		b.eq	scoreValidate
		b.ne	scorenotLow		

scoreValidate:	adr	x1, zero
		ldr	d1, [x1]
		fcmp	d10, d1					// if score < 0 , branch to scoreLow which then branches to m_break in order to call exitGame
		b.le	scoreLow
		b.gt	scorenotLow				// if score > 0 bracnh to scorenotLow

scoreLow:	adrp	x0, gameOver2		
		add	x0, x0, :lo12:gameOver2
		bl	printf					// print gameover2 string and bracnh to m_break
		b	m_break

scorenotLow:	sub	x0, fp, table_s     			// pass table base address
		mov	x1, x19					// N
		bl	checkBoard				// call checkBoard
		mov	x26, x0					// update allDiscovered, set allDiscovered to 1 after each cell visited once
	
		cmp	x26, 1					// if allDiscovered == 1, branch to discoveredAll
		b.eq	discoveredAll
		b.ne	undisc					// if not, bracnh tp undisc

discoveredAll:	adrp	x0, gameOver3				// print gameover3 string adn call m_break
		add	x0, x0, :lo12:gameOver3
		bl	printf
		b	m_break

undisc:		adrp	x0, decide
		add	x0, x0, :lo12:decide			// ask user to decide whether to quit or continue
		bl	printf					// call printf

		adrp	x0, formatIn
		add	x0, x0, :lo12:formatIn
		adr	x1, response
		bl	scanf					// store response using scanf
	
		adr	x1, response
		ldr	w21,[x1]		
		
		adrp	x0, newLine				// print newline
		add	x0, x0, :lo12:newLine
		bl	printf
		
		sub	x0, fp, table_s				// pass table base address
		mov	x1, x19					// N
		fmov	d0, d10					// score
		fmov	d1, d8					// time remaining
		bl	displayGame				// call displayGame
		mov	x22, 1					// set firstMove to 1

		cmp	w21, 0					// if input == 0
		b.eq	m_loopBack				// branch back to m_loopBack
		b.ne	m_break					//if not, branch to m_break

m_break:	mov	x0, x20					// N
		fmov	d0, d10					// score
		fmov	d1, d8					// remaining time
		fmov	d2, d9					// total time
		bl	exitGame				// call exitGame

		add	sp, sp,deallocateMem			// deallocate memory by adding deallocMem to it 
		
done:		mov	w0, 0
		ldp	x29, x30, [sp] , m_dealloc		// deallocate memory for main and restore fp and lr to initial values
		ret						// return to calling code
