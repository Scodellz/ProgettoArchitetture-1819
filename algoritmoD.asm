.data
	inputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/input.txt"
	outputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/output.txt"
	inputMessage: 	.space	255
	outputMessage:	.space	255
	
.text

main:

open:
	li	$v0, 13				# Apertura File
	la	$a0, inputFile			# Carico il file in input
	li	$a1, 0				# Flag di lettura (0)
	li	$a2, 0				# (ignorato)
	syscall
	
	move	$t6, $v0				# Salvo il descrittore del file in $t6

read:
	li	$v0, 14				# Lettura del File
	move	$a0, $t6				# Carico il descrittore del file
	la	$a1, inputMessage		# Carico il buffer
	li	$a2, 255				# Imposto lo spazio del buffer
	syscall
	
	move	$a2, $a1				# Metto descrittore file in $a2
	move	$t0, $zero			# Inizializzo contatore degli elementi della stringa a 0
	la	$a3, outputMessage		# Carico il buffer che conterrà il messaggio da restituire in $a3
	
counter:						# Metodo che conta quanti elementi sono presenti nel buffer
	lbu	$t1, ($a2)			# Carico il carattere puntato in $t1
	beqz	$t1, endPointer			# Se sono arrivato alla fine della stringa il metodo termina
	addi	$t0, $t0, 1			# Altrimenti aumento il contatore di 1
	addi	$a2, $a2, 1			# Scorro alla posizione successiva del buffer
	
	j 	counter				# Inizio un nuovo ciclo

endPointer:
	addi	$a2, $a2, -1			# Dato che il il puntatore e' fuori dal buffer, lo faccio tornare
						# indietro di una posizione
	move	$s0, $t0				# Dato che e' il numero degli elementi rimarra' invariato lo salvo in $s0
	move	$t0, $zero			# Reinizializzo $t0 per contare il numero di elementi che verranno inseriti

reversal:					# Metodo di inversione				
	beq	$t0, $s0, print			# Se il numero dei caratteri inseriti è pari alla lunghezza del buffer
						# allora posso stampare su file il buffer di output	
	lbu	$t1, ($a2)			# Altrimenti metto in $t1 l'elemento del buffer di input
	sb	$t1, ($a3)			# e lo salvo nel buffer di uscita

	subi	$a2, $a2, 1			# Vado al carattere precedente del buffer di input
	addi	$a3, $a3, 1			# Scorro alla posizione successiva del buffer di output
	addi	$t0, $t0, 1			# Aumento di 1 il contatore dei caratteri inseriti
	j 	reversal
	
print:						# Stampa su file di output
	li	$v0, 13				# Apertura File
	la	$a0, outputFile			# Carico il file di output
        li 	$a1, 1            		# Flag di scrittura (1)
        li 	$a2, 0				# (ignorato)
	syscall
	
	move	$t1, $v0				# Salvo il descrittore del file in $t1

	li	$v0, 15				# Scrittura nel file
	move	$a0, $t1    			# Carico il descrittore del file in $a0
	la	$a1, outputMessage		# Carico il buffer di output
	move	$a2, $s0				# Imposto lo spazio del buffer grazie al contatore degli elementi $s0
	syscall

close:
	li	$v0, 16				# Chiudo il file "input.txt"
	move	$a0, $t6				# Carico il descrittore del file
	syscall
	
	li	$v0, 16				# Chiudo il file "output.txt"
	move	$a0, $t1				# Carico il descrittore del file
	syscall

exit:
	li	$v0, 10				# Chiudo il programma
	syscall
