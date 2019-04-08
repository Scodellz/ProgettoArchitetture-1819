.data
	bufferReader:		.space	5	# questo sarà la stringa da cifrare, in questo caso usero il file chiave
	occurrences:		.space  5	# conterra le occorenze della stringa letta 
	
	chiave:			.asciiz 	".marSETUP/chiave4.txt"

.align 2
.text
main:
openFile:	li	$v0, 13
		la	$a0, chiave
		li	$a1, 0
		li	$a2, 0
		syscall		
		move	$s0,$v0		# salvo il descrittore del file
readFile:	
		li 	$v0, 14
		move	$a0, $s0 
		la	$a1, bufferReader
		li 	$a2, 5
	 	syscall	
	 	move	$s0, $a1	# salvo il riferimento del buffer
	 	
	 	la	$s4, occurrences  
	 	
counterOcc:	li	$s2, 0		# inizializzo i contatori
		li	$s3, 0
		
		lb	$t0, ($s0)
		beq	$t0, $zero, exit
		
		
		move	$s4, $t0
		
		
	 	

	 	
