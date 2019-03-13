.data
	fnf:		.ascii  	"Il file non è stato trovato: "
	input:		.asciiz		"input.txt"
	output:		.asciiz  	"output.txt"
	buffer: 	.space 		4	# <- 10024


.text
main:

open:
	li	$v0, 13			# Apertura File
	la	$a0, input		# Carico il file in input
	li	$a1, 0			# Flag di lettura (0)
	li	$a2, 0			# (ignorato)
	syscall
	
	move	$t6, $v0		# Salvo il descrittore del file in $t6
	blt	$v0, 0, err		# Se il file è vuoto gestisco l'errore
 
read:
	li	$v0, 14			# Lettura del File
	move	$a0, $t6		# Carico il descrittore del file
	la	$a1, buffer		# Carico il buffer
	li	$a2, 4			# Imposto lo spazio del buffer <- 10024
	syscall

print:
	li	$v0, 13			# Apertura File
	la	$a0, output		# Carico il file di output
        li 	$a1, 1            	# Flag di scrittura (1)
        li 	$a2, 0			# (ignorato)
	syscall
	
	move	$t1, $v0		# Salvo il descrittore del file in $t1

	li	$v0, 15			# Scrittura nel file
	move	$a0, $t1    		# Carico il descrittore del file
	la	$a1, buffer		# Carico il buffer
	li	$a2, 4			# Imposto lo spazio del buffer <-10024
	syscall

close:
	li	$v0, 16			# Chiudo il file "input"
	move	$a0, $t6		# Carico il descrittore del file
	syscall

	li	$v0, 16			# Chiudo il file "output"
	move	$a0, $t1		# Carico il descrittore del file
	syscall

	li	$v0, 10			# Chiudo il programma
	syscall		
 
err:
	li	$v0, 4			# Stampo la stringa di errore
	la	$a0, fnf		# "Il file non è stato trovato: "
	syscall

	li	$v0, 10			# Chiudo il programma
	syscall	
