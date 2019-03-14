.data
	fnf:		.ascii  		"Il file non e' stato trovato: "
	input:		.asciiz		"C:/Users/duxom/Desktop/Mars/input.txt"
	#output:		.asciiz  	"C:/Users/duxom/Desktop/Mars/output.txt"
	buffer: 	.space 		4	# <- 10024


.text
main:

open:
	li	$v0, 13			# Apertura File
	la	$a0, input		# Carico il file in input
	li	$a1, 0			# Flag di lettura (0)
	li	$a2, 0			# (ignorato)
	syscall
	
	move	$t6, $v0			# Salvo il descrittore del file in $t6
	blt	$v0, 0, err		# Se il file è vuoto gestisco l'errore
 
read:
	li	$v0, 14			# Lettura del File
	move	$a0, $t6			# Carico il descrittore del file
	la	$a1, buffer		# Carico il buffer
	li	$a2, 4			# Imposto lo spazio del buffer <- 10024
	syscall
	
	move	$a3, $a1			# Metto descrittore file in $a3
	move	$t0, $zero		# Inizializzo contatore dei caratteri della stringa a 0
	
counter:
	lbu	$t1, ($a3)		# Carico il carattere puntato in $t1
	beqz	$t1, endPointer		# Se sono arrivato alla fine della stringa posso passare alla stampa
	addi	$t0, $t0, 1		# Altrimenti aumento il contatore di 1
	addi	$a3, $a3, 1
	
	j 	counter

endPointer:
	la	$a3, buffer
	subi	$t0, $t0, 1		# Dato che ho contato un carattere in più, diminuisco il contatore
	add	$a3, $a3, $t0		# Metto il puntatore all'ultimo carattere della frase

reversePrint:
	lbu	$t1, ($a3)		# Carico carattere indicato dal puntatore
	beq	$t1, 0, close		# Se è null significa che siamo alla fine della stringa
					# quindi termino il programma
	
	li	$v0, 11			# Stampa char
	lbu	$a0, ($a3)		# Carico carattere indicatore dal puntatore
	syscall
	
	subi	$a3, $a3, 1		# Vado al carattere successivo
	j 	reversePrint
	

close:
	li	$v0, 16			# Chiudo il file "input"
	move	$a0, $t6			# Carico il descrittore del file
	syscall

	li	$v0, 10			# Chiudo il programma
	syscall		
 
err:
	li	$v0, 4			# Stampo la stringa di errore
	la	$a0, fnf			# "Il file non è stato trovato: "
	syscall

	li	$v0, 10			# Chiudo il programma
	syscall	
