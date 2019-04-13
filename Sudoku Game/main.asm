INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 97
.DATA
TimePassed dword ?
Time byte "The Time You Took To Playing The Game : ",0
NoPrevGame byte "There is no previous paused Game to continue",0
Choice1 byte "Start New Game Press 1",0
Choice2 byte "Continue Last Previously Played Game Press 2",0
Choice3 byte "Press Your Choice Number : ",0
LoadedFileAnswer byte "SolvedLoaded.txt",0
LoadedFileTest byte "UnSolvedLoaded.txt",0
ClearingFileTest byte "ClearingFileTest.txt", 0
SolvHolder BYTE BUFFER_SIZE DUP(?)
UnSolvHolder BYTE BUFFER_SIZE DUP(?)
ClearHolder BYTE BUFFER_SIZE DUP(? )
SolvedArr BYTE BUFFER_SIZE DUP(?)
UnSolvedArr BYTE BUFFER_SIZE DUP(?)
ChClArr byte BUFFER_SIZE dup(?)
fileHandle HANDLE ?
UnSolvedSFileName byte "diff_?_?.txt", 0
SolvedSFileName byte "diff_?_?_solved.txt", 0
ChooseLevelString byte "Choose the Difficulty Level : ", 0
Level1String byte "For Easy Level Enter 1", 0
Level2String byte "For intermediate level Enter 2", 0
level3String byte "For Difficult Level Enter 3", 0
EnterLevelString byte "Enter Your Level Choice : ", 0
Option1string byte "To Print the Finished Board Press 1",0
Option2string byte "To Clear the Board to the Initial Sudoku Board Press 2",0
Option3string byte "To Edit a Single Cell in the Board Press 3",0
Option4string byte "To Save and Exit Press 4",0
MissedNumbers byte "The Count of Missed Numbers : ",0
IncorrectNumString byte "The Number of Times You Entered An Incorrect Solution : ",0
CorrectNumString byte "The Number of Times You Entered An Correct Solution : ", 0
CompletedString byte "Congratulations!! You Successfully Completed the Game",0
HGrids byte "   1 2 3 4 5 6 7 8 9",0
VGrids byte "  -------------------",0
;//this the solved Array you will change it to (SolvedArr byte 81 dup(?))
;//I made it 9 only to try and check it how it works
;//this the UnSolved Array you will change it to (SolvedArr byte 81 dup(?))

GridCounter byte 0
CorrectENum byte 0 ;//Counter Coount How many user Enterd Correct Numbers
IncorrectENum byte 0 ;//Counter Coount How many user Enterd InCorrect Numbers

;//String tells user How he Can Enter a value in specific Postion
InputString byte "Enter value , x and y : ", 0

NumCols = 9 ;// constant number of Columns in Sudoku You will Change it To NumCols = 9
NumRows = 9 ;// constant number of Rows in Sudoku You will Change it To NumRows = 9

RowNumber byte ? ;// The x Postion The user will Enter

ColumnNumber byte ? ;// The Y Postion The user will Enter

value byte ? ;// The value The user will Enter To put it in the (x,y) Postion

;//Counter will count The number of zeros in unsolved array and when user Enter correct value it will be decreased
;// And we will count zeros using CountingUnSolvedCells Procedure
UnSolvedCells byte 0

;//Messege will appear to user if he entered incorrect value in (x,y) postion
InvalidInput byte "You Enterd Invalid Value", 0
ValidInput byte "Great, You Entered Correct Value",0

.code

;// This proc take the value and (x.y) position to put insudoku 
InputValue proc, xvalue:byte, xRowNumber : byte, xColumnNumber : byte

;//using (x,y) position we will get postion as 2d array in solved array 
mov eax, byte ptr NumCols
mul xRowNumber
mov ebx, eax
mov edx, 0
movzx esi, ColumnNumber
mov al, xvalue
cmp SolvedArr[ebx + esi], al
;//after this comparing the value in x,y position with the value user had enterd
jne NotE
;// if the value eaual the value in solved array decrement unsolved Cells counter
;// increment Correct entered numbers couner
dec UnSolvedCells
inc CorrectENum;
;// beacuase of the value is correct put in unsolved array
mov UnSolvedArr[ebx + esi], al
mov eax, lightgreen+(white*16)
call SetTextColor
mov edx,offset ValidInput
call writestring
call crlf
call crlf
jmp done

;// if the value is incorrect display messege
NotE:
mov eax,lightred+(white*16)
call SetTextColor
mov edx, offset InvalidInput
call writestring
call crlf
call crlf
inc IncorrectENum ;//increment incorrect numbers counter 

done:
;// then calling display proc to display unsolved arr after inpu value even the the value is incorrect
mov eax, black + (white * 16)
call SetTextColor
call DisplayUnSolvedS
call crlf
ret
InputValue endp

;// Displaying Solved Sudoku Array
DisplaySolvedS proc

mov ecx, 9 ;//change it to mov ecx,9 because I was try in small scale
 
call LightGreenColor
 mov edx, offset HGrids
 call writestring
 call crlf
call BlackColor
mov edx, 0 ;//point at the begining of solved arr
L3 :
call Group1

push ecx ;// pushing the current ecx before mov another value in it 		
mov ecx, 9 ;//change it to mov ecx,9 because I was try in small scale 3*3
		
		;// this loop display a line of sudoku number by number
	L4 :
			call CheckPrintIn
			mov bl, UnSolvedArr[edx]
			cmp bl,0
			jne next
			call LightBlueColor
			mov al,SolvedArr[edx]
			call writedec
			jmp endf
			next:
			call BlackColor
			mov al, SolvedArr[edx]
			call writedec
			endf:
			call BlackColor
			inc edx
			loop L4
		;// return the row number of sudoku (previous value) 
			
			call BlackColor	
			mov al, "|"
			call writechar
			call crlf
		pop ecx
		loop L3
		call DisplayVGrids
		mov GridCounter,0
		ret
DisplaySolvedS endp


CheckPrintIn proc
cmp ecx, 1
jne P
mov al, " "
call writechar
jmp done
P:
push edx
mov eax, ecx
cdq
mov esi, 3
div esi
cmp edx, 0
jne notprint
mov al, "|"
call writechar
pop edx
jmp done
notprint :
mov al," "
call writechar
pop edx
done:
ret
CheckPrintIn endp

CheckPrintOut proc
push edx
mov eax, ecx
cdq
mov esi, 3
div esi
cmp edx, 0
jne notprint
call DisplayVGrids
notprint:
pop edx
ret
CheckPrintOut endp


DisplayVGrids proc
push edx
mov edx,offset VGrids
call writestring
call crlf
pop edx
ret
DisplayVGrids endp

BlackColor proc
mov eax, black + (white * 16)
call SetTextColor
ret
BlackColor endp

LightBlueColor proc
mov eax, lightblue + (white * 16)
call SetTextColor
ret
LightBlueColor endp

LightGreenColor proc
mov eax, lightgreen + (white * 16)
call SetTextColor
ret
LightGreenColor endp


Group1 proc
call CheckPrintOut
call LightGreenColor
inc GridCounter
mov al, GridCounter
call writedec
call BlackColor
mov al, " "
call writechar
ret
Group1 endp
;// Displaying Solved Sudoku Array
DisplayUnSolvedS proc
mov ecx, 9 ;//change it to mov ecx,9 because I was try in small scale 3*3
call LightGreenColor
mov edx, offset HGrids
call writestring
call crlf
call BlackColor
mov edx,0  ;//point at the begining of unsolved arr
L3 :
		call Group1
		push ecx ;// pushing the current ecx before mov another value in it 
		mov ecx, 9 ;//change it to mov ecx,9 because I was try in small scale 3*3
		
		;// this loop display a line of sudoku number by numbe
		L4 :
		call CheckPrintIn
		mov bl, UnSolvedArr[edx]
		cmp bl,0
		jne next
		mov al," "
		call writechar
		jmp endf
		next:
		mov bl, ChClArr[edx]
		cmp bl,0
		jne next2
		call LightRedColor
		mov al,UnSolvedArr[edx]
		call writedec
		jmp endf
		next2:
		call BlackColor
		mov al, UnSolvedArr[edx]
		call writedec
		endf:
		call BlackColor
		inc edx
		loop L4
		mov al, "|"
		call writechar
		call crlf
		;// return the row number of sudoku (previous value)
		pop ecx
		loop L3
		call DisplayVGrids
		mov GridCounter,0
		ret
DisplayUnSolvedS endp

LightRedColor proc
mov eax, lightred + (white * 16)
call SetTextColor
ret
LightRedColor endp
DisplayChClS proc
mov ecx, 9;//change it to mov ecx,9 because I was try in small scale 3*3
		mov ebx, offset ChClArr;//point at the begining of unsolved arr
	L3:
		push ecx;// pushing the current ecx before mov another value in it 
		mov ecx, 9;//change it to mov ecx,9 because I was try in small scale 3*3

		;// this loop display a line of sudoku number by numbe
	L4:
		mov al, [ebx]
			inc ebx
			call writedec
			loop L4

			;// return the row number of sudoku (previous value)
		pop ecx
			call crlf
			loop L3
			ret
DisplayChClS endp
;// this Proc Counting the number of zeros in the Unsolved Array
;// So I can loop on the unsolved cells counter in the main and tells the user to input
;// value to fill the Unsolved Sudoku
CountingUnSolvedCells proc

mov edx, offset UnSolvedArr ;//point at the begining of the unsolved array
;//I will loop 9 time (my small scale 3*3 on the array to count zeros
;// Change it to 81 in 3bdo to change scale
mov ecx,81
L1:
	;// compare the every elemnt with zero if it is zero increment the unsolved cells counter
	mov al, 0
		cmp [edx], al
		jne L2
		inc UnSolvedCells
		L2 :
		Add edx, type UnSolvedArr
		loop L1

		movzx eax, UnSolvedCells ;// display the unsolved cells to user
		;// call writedec
		;// call crlf
		ret
CountingUnSolvedCells endp

;// this function that read Solved suduko
    readSOLV PROC
		call OpenInputFile
		mov fileHandle,eax
		cmp eax,INVALID_HANDLE_VALUE
		je exit1
		mov edx,offset SolvHolder
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jmp cont
		exit1:
		mov edx,offset NoPrevGame
		call writestring
		call crlf
			exit
			cont:
		ret
	readSOLV ENDP
	;//
	;// this function that read unSolved suduko
		readUNSOLV PROC
		call OpenInputFile
		mov fileHandle,eax
		mov edx,offset UnSolvHolder
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		ret
	readUNSOLV ENDP
	;//
		;// this function that read unSolved suduko
		ReadOriginal PROC
			call OpenInputFile
			mov fileHandle, eax
			mov edx, offset ClearHolder
			mov ecx, BUFFER_SIZE
			call ReadFromFile
			ret
		ReadOriginal ENDP
			;//
;// Choosing Level Proc takes the difficulty level fron user and change set files names
ChoosingLevel PROC

mov edx, OFFSET ChooseLevelString
call WriteString
call crlf
mov edx, offset Level1String
call WriteString
call crlf
mov edx, offset Level2String
call WriteString
call crlf
mov edx, offset Level3String
call WriteString
call crlf
mov edx, offset EnterLevelString
call writestring
call readchar
;// Display the number the user entered
call writechar
;// set the difficulty level to files names
mov[UnSolvedSFileName + 5], al
mov[SolvedSFileName + 5], al

;// this part generate random number of the models of sudoku
rdtsc
shr eax,2
mov eax,[ebp+12]
mov ebx,3
cdq
div ebx
inc edx
movzx eax,dl
add al,"0"
call crlf
;// display the generated random number to check it is correct generated
;// call writechar
;// call crlf
;//moving the generated random number for model (1 or 2 or 3) to files names
mov[UnSolvedSFileName + 7], al
mov[SolvedSFileName + 7], al
;// display the Unsolved Sudoku File name
;// mov edx, offset UnSolvedSFileName
;// call writestring
;// call crlf
;// display the Solved Sudoku File name
;// mov edx, offset SolvedSFileName
;// call writestring
call crlf
ret
ChoosingLevel endp
	;//this for reading from files and put in arrays 
	ConvertFromCharToNumbers proc
	;// this code convert array of chars to array of numbers UnSolvedArr
		mov edx,OFFSET UnSolvHolder
		mov ebx,OFFSET UnSolvedArr 
		mov ecx,BUFFER_SIZE
	l1:
		movzx eax,byte ptr[edx]
		sub eax,48
		cmp eax,9
		ja skip
		mov byte ptr[ebx],al
		jmp ex
		skip:
		dec ebx
		ex:
		inc edx
		inc ebx
			loop l1
			;// end
		;// this code convert array of chars to array of numbers for the SolvedArr
		mov edx,OFFSET SolvHolder
		mov ebx,OFFSET SolvedArr
		mov ecx,BUFFER_SIZE
	l2:
		movzx eax,byte ptr[edx]
		sub eax,48
		cmp eax,9
		ja skip1
		mov byte ptr[ebx],al
		jmp ex1
		skip1:
		dec ebx
		ex1:
		inc edx
		inc ebx
			loop l2
			;// end
		
			ret
	ConvertFromCharToNumbers endp
	
	ClearConverting proc
				mov edx, OFFSET ClearHolder
				mov ebx, OFFSET ChClArr
				mov ecx, BUFFER_SIZE
				l3 :
			movzx eax, byte ptr[edx]
				sub eax, 48
				cmp eax, 9
				ja skip2
				mov byte ptr[ebx], al
				jmp ex2
				skip2 :
			dec ebx
				ex2 :
			inc edx
				inc ebx
				loop l3
	ret
		ClearConverting endp
	YourChoice proc
		mov edx ,offset Choice1
		call writestring
		call crlf
		mov edx,offset Choice2
		call writestring
		call crlf
		mov edx,offset Choice3
		call writestring
		call readdec
		call crlf
		cmp al,1
	jne load
		L:	call ChoosingLevel
			mov edx,offset UnSolvedSFileName
			call readUNSOLV
			mov edx,offset SolvedSFileName
			call readSOLV
			call ConvertFromCharToNumbers
			call CountingUnSolvedCells
			call FillTheChClArr
			
			jmp new1
	load:
			mov edx,offset LoadedFileTest
			call readUNSOLV
			mov edx,offset LoadedFileAnswer
			call readSOLV
			mov edx ,offset ClearingFileTest
			call ReadOriginal
			call ClearConverting
			call ConvertFromCharToNumbers
			call CountingUnSolvedCells
			cmp UnSolvedCells,0
			jne new1
			mov edx,offset NoPrevGame
			call writestring
			call crlf
			jmp L 
		new1:
		ret
	YourChoice endp

	CreateNewFile proc
	call ConvertFromNumbersToChar
		mov edx,offset LoadedFileTest
		call CreateOutputFile
		mov fileHandle,eax
		mov edx,offset UnSolvHolder
		mov ecx,BUFFER_SIZE
		call WriteToFile
		mov edx,offset LoadedFileAnswer
		call CreateOutputFile
		mov fileHandle,eax
		mov edx,offset SolvHolder
		mov ecx,BUFFER_SIZE
		call WriteToFile
		mov edx, offset ClearingFileTest
		call CreateOutputFile
		mov fileHandle, eax
		mov edx, offset ClearHolder
		mov ecx, BUFFER_SIZE
		call WriteToFile
		ret
CreateNewFile endp

FillTheChClArr proc
mov ecx,81
mov ebx,0
L:
	mov al,UnSolvedArr[ebx]
	mov ChClArr[ebx],al
	inc ebx
	loop L
ret
FillTheChClArr endp

ClearingUnSolvedS proc
mov ecx, 81
mov ebx, 0
L:
	mov al, ChClArr[ebx]
		mov UnSolvedArr[ebx], al
		inc ebx
		loop L
		mov CorrectENum, 0
		mov IncorrectENum,0
		ret
ClearingUnSolvedS endp
ConvertFromNumbersToChar proc
			;// this code convert array of chars to array of numbers UnSolvedArr		
			mov edx, OFFSET UnSolvedArr
			mov ebx, OFFSET UnSolvHolder
			mov ecx, 9
LOut:
			push ecx
			 mov ecx, 9
		Lin :
			movzx eax, byte ptr[edx]
			add al, 48
			 mov byte ptr[ebx], al
			 inc edx
			 inc ebx
		loop Lin
			mov byte ptr[ebx],13
			inc ebx
			mov byte ptr[ebx],10
			inc ebx
			pop ecx
loop LOut
;//////////////////////////
			mov edx, OFFSET ChClArr
			mov ebx, OFFSET ClearHolder
			mov ecx, 9
LOut1:
			push ecx
			 mov ecx, 9
		Lin1:
			movzx eax, byte ptr[edx]
			add al, 48
			 mov byte ptr[ebx], al
			 inc edx
			 inc ebx
		loop Lin1
			mov byte ptr[ebx],13
			inc ebx
			mov byte ptr[ebx],10
			inc ebx
			pop ecx
loop LOut1
			ret ;// end
		ConvertFromNumbersToChar endp
;//the main Proc
main PROC
INVOKE GetTickCount
mov TimePassed,eax
		mov eax, black + (white * 16)
		call SetTextColor
		call YourChoice
		;//Display Unsolved Sudoku To user
		 call DisplayUnSolvedS
		call crlf
		;//call DisplaySolvedS
		 ;// call crlf
		
		
			beginwhile :
			mov	edx,offset Option1string
			call writestring
			call crlf
			mov	edx, offset Option2string
			call writestring
			call crlf
			mov	edx, offset Option3string
			call writestring
			call crlf
			mov	edx, offset Option4string
			call writestring
			call crlf
			mov edx,offset Choice3
			call writestring
			call readdec
			call crlf
			
				
			cmp al,1
			jne next1
			call DisplaySolvedS
			call crlf
			mov edx,offset MissedNumbers
			call writestring
			movzx eax,UnSolvedCells
			call writedec
			call crlf
			jmp endwhile
			next1:

			cmp al,2
			jne next2
			call ClearingUnSolvedS
			call DisplayUnSolvedS
			call crlf
			jmp beginwhile
			next2:

			cmp al,3
			jne next3

			mov edx, offset InputString
			call writestring
			call crlf

			call readdec
			mov value, al

			call readdec
			dec al
			mov RowNumber, al

			call readdec
			call crlf
			dec al
			mov ColumnNumber, al
			invoke InputValue, value, RowNumber, ColumnNumber
			
			movzx ebx,UnSolvedCells
			cmp ebx,0
			jne notcomp
			mov edx,offset CompletedString
			call crlf
			jmp endwhile
			notcomp:
			jmp beginwhile
			next3:
			
			cmp al,4
			jne next4
			jmp SaveAndExit
			next4:
			jmp beginwhile
			endwhile :


			
			
			
		

	Finish:
	

	mov edx,offset IncorrectNumString
	call writestring		
	movzx eax, IncorrectENum
	call writedec
	call crlf
	
	mov edx, offset CorrectNumString
	call writestring
	movzx eax, CorrectENum
	call writedec
	call crlf
	
	
		INVOKE GetTickCount
		sub eax, TimePassed
		cdq
		mov ebx, 1000
		div ebx
		mov edx, offset Time
		call writestring
		call writedec
		mov al, ' '
		call writechar
		mov al, 's'
		call writechar
		call crlf
		
		
	SaveAndExit:
	call CreateNewFile
	
	exit
main ENDP
END main