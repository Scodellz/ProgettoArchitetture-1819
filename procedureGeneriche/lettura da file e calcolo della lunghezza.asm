.data
	buffer:		.space		255
	inputfile:	.asciiz 	".marSETUP/messaggio.txt"
	cripted:	.asciiz		" cripted content:"
	
.align 2
.text 

main:	

open:	li	$v0, 13		 # apri il file	
	la	$a0, inputfile
	li	$a1, 0
	li	$a2, 0
	syscall	
	move	$t0, $v0 	# slaviamo il percorso del file
	
read:	li	$v0, 14		# si legge e sia carica il contenuto del file
	move	$a0, $t0
	la	$a1, buffer
	li	$a2, 255
	syscall	
	move 	$a3, $a1	# salviamo il percorso del baffer con gli elementi da convertire
	
findLen: lbu	$t0, ($a3)	# troviamo la lunghezza della stringa nel buffer
	 beq    $t0, 10 , STAMPA
	 addi   $t1, $t1, 1     # RITORNERA LA LUNGHEZZA DELLA STRING IN $T1
	 addi	$a3, $a3, 1
	 j 	findLen	




	
	

	