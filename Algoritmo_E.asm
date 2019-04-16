# FUNZIONA CON SCRITTURA SU FILE!! UNICO PROBLEMA è CHE STAMPA SPAZI VUOTI PERCHé MANCA UN CONTATORE DI ELEMENTI

.data
	inputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/input.txt"
	outputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/output.txt"
	bufferReader:	.space	1500
	supportBuffer:	.space	1500
	outputBuffer:	.space	1500
	
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
	la	$a1, bufferReader		# Carico il buffer
	li	$a2, 1500			# Imposto lo spazio del buffer
	syscall
	
E:
	
	la	$a1, bufferReader		# Carico il buffer che contiene il messaggio da cifrare
	la	$a2, supportBuffer		# Carico il buffer che conterrà gli elementi presenti in bufferReader
						# ripetuti una sola volta
	jal	occurrence			# Salto al metodo che crea tale buffer

	la	$a2, supportBuffer		# Rimetto il puntatore all'inizio del buffer
	la	$a3, outputBuffer		# Carico il buffer che conterrà il messaggio criptato
	move	$t5, $zero			# Imposto il contatore degli elementi inseriti in outputBuffer a 0
	jal	writer				# Salto al metodo che produce l'output di cifratura
	
	li	$v0, 4
	la	$a0, outputBuffer		# STAMPA TEMPORANEA
	syscall
	
print:						# Stampa su file di output
	li	$v0, 13				# Apertura File
	la	$a0, outputFile			# Carico il file di output
        li 	$a1, 1            		# Flag di scrittura (1)
        li 	$a2, 0				# (ignorato)
	syscall
	
	move	$t1, $v0				# Salvo il descrittore del file in $t1

	li	$v0, 15				# Scrittura nel file
	move	$a0, $t1    			# Carico il descrittore del file in $a0
	la	$a1, outputBuffer		# Carico il buffer di output
	subi	$t5, $t5, 1			# Dato che e' stato inserito un ' ' aggiuntivo, non lo prendo in considerazione
	move	$a2, $t5				# Imposto lo spazio del buffer grazie al contatore degli elementi $t5
	syscall

close:
	li	$v0, 16				# Chiudo il file "input.txt"
	move	$a0, $t6				# Carico il descrittore del file
	syscall
	
	li	$v0, 16				# Chiudo il file "output.txt"
	move	$a0, $t1				# Carico il descrittore del file
	syscall

exit:
	li	$v0, 10				# Termine dell'algoritmo
	syscall
	
occurrence:					# Inizio del metodo che riempe supportBuffer
	lbu	$t1, ($a1)			# Carico in $t1 il carattere puntato di bufferReader
	beqz	$t1, finish			# Se sono alla fine del buffer allora il metodo termina

control:						# Frammento di metodo che riconosce se un elemento e' gia' stato inserito	
	lbu	$t2, ($a2)			# Carico l'elemento puntato in $t2
	beqz	$t2, firstOccurrence		# Se in quella posizione non e' presente alcun elemento allora e' la prima
						# volta che viene trovato. Vado quindi a "firstOccurrence"
	beq	$t1, $t2, ignore			# Se gli elementi sono uguali invece vado a "ignore"
	addi	$a2, $a2, 1			# Altrimenti se sono diversi scorro di una posizione il buffer delle
	j	control				# occorrenze per controllare se l'elemento e' gia' stato trovato prima
						# oppure e' la prima volta
firstOccurrence:					# Metodo che gestisce la prima occorrenza di un elemento
	sb	$t1, 0($a2)			# Salvo l'elemento che ho trovato nel buffer delle occorrenze
	addi	$a1, $a1, 1			# Vado alla posizione successiva di bufferReader
	la	$a2, supportBuffer		# Rimetto il puntatore all'inizio del buffer delle occorrenze
	j	occurrence			# e inizio nuovamente a cercare le prime occorrenze degli elementi
	
ignore:						# Metodo che ignora un elemento in caso di uguaglianza
	addi	$a1, $a1, 1			# Scorro alla posizione successiva di bufferReader
	la	$a2, supportBuffer		# Rimetto il puntatore all'inizio del buffer delle occorrenze
	j	occurrence			# e inizio nuovamente a cercare le prime occorrenze degli elementi

finish:						# Metodo che torna al metodo principale dell'algoritmo
	jr	$ra
	
writer:						# Metodo che inizia il ciclo di cifratura del messaggio
	la	$a1, bufferReader		# Torno all'inizio di bufferReader per leggere il messaggio
	move	$t0, $zero			# Inizializzo il contatore delle posizioni
	
elements:					# Metodo che scorre il buffer delle occorrenze per esaminare uno
						# specifico elemento all'interno di bufferReader
	lbu	$t2, ($a2)			# Carico l'elemento puntato di supportBuffer in $t2
	beqz	$t2, end				# Se e' arrivato alla fine del buffer allora l'algoritmo termina
	sb	$t2, 0($a3)			# Altrimenti salvo $t2 all'interno di outputBuffer, in modo tale che
						# evidenzi l'elemento preso in esame in supportBuffer
	addi	$a3, $a3, 1			# Vado alla posizione successiva di outputBuffer
	addi	$t5, $t5, 1			# Dato che ho inserito un elemento aumento il contatore $t5 di 1
	
positions:					# Metodo che stampa le posizioni in cui si trova l'elemento esaminato
	lbu	$t1, ($a1)			# Carico l'elemento puntato di bufferReader in $t1
	beqz	$t1, nextElement			# Se sono alla fine del buffer allora vuol dire che ho controllato tutte le 
						# occorrenze dell'elemento puntato in supportBuffer, e posso andare al prossimo
	bne	$t1, $t2, nextControl		# Se $t1 e $t2 sono diversi allora vado al metodo che scorre al controllo
						# successivo sul bufferReader
	li	$t3, '-'				# Altrimenti carico il simbolo '-'
	sb	$t3, 0($a3)			# e lo salvo in outputBuffer per separare le occorrenze

	addi	$t5, $t5, 1			# Dato che ho inserito un elemento in outputBuffer aumento $t5 di 1
	
	move	$t4, $t0				# Metto in $t4 il contatore delle posizioni
	move	$t8, $zero			# Inizializzo il contatore delle cifre
	
	sgt	$t7, $t4, 9			# Se il contatore e' superiore a 9 imposto $t7 a 1
	beq	$t7, 1, digitsCounter		# In tal caso vado al metodo che gestisce il salvataggio di cifre multiple
		
storeDigit:					# Metodo che salva una sola cifra
	move	$s0, $t8				# Salvo il numero delle cifre nella costante s0
	sgt	$t7, $t8, 1			# Se il numero delle cifre e' maggiore di 1
	beq	$t7, 1, storeDigits		# Allora vuol dire che e' dell'ordine delle decine
	
	addi	$a3, $a3, 1			# Avanzo di uno perche' puntatore punta a "-"
	addi	$t0, $t0, 48			# Altrimenti salvo direttamente la cifra
	sb	$t0, 0($a3)
	subi	$t0, $t0, 48
	
	addi	$a3, $a3, 1
	addi	$t5, $t5, 1
	
nextControl:
	addi	$a1, $a1, 1
	addi	$t0, $t0, 1			# T0 CONTA LE POSIZIONI
	j	positions
	
nextElement:
	li	$t3, ' '
	sb	$t3, 0($a3)
	
	addi	$a3, $a3, 1
	addi	$t5, $t5, 1
	addi	$a2, $a2, 1
	
	j	writer
	
digitsCounter:					# Metodo che conta da quante cifre e' formata l'occorrenza 
	beqz	$t4, storeDigit			#  
	li	$t9, 10
	div	$t4, $t9
	mflo	$t4
	addi	$t8, $t8, 1
	j	digitsCounter
	
storeDigits:					# Metodo che salva in outputBuffer occorrenze con piu' di una cifra
	add	$a3, $a3, $s0			# Avanzo del numero di cifre corretto
	move	$t4, $t0				# Metto in $t4 il contatore delle posizioni
	#move	$t8, $zero			# Inizializzo il contatore delle cifre
	
storeCicle:
	li	$t8, 10				# T8 e' il valore 10 per la divisione
	div	$t4, $t8				# Contatore posizioni/10
	mflo	$t4				# Quoziente
	mfhi	$t9				# Resto
	
	addi	$t9, $t9, 48			# Aggiungo 48 al resto per trasformarlo in ASCII
	sb	$t9, ($a3)			# Salvo il resto in posizione giusta
	beqz	$t4, offset			# Se il numero e' stato tutto stampato finisco il ciclo
	
	subi	$a3, $a3, 1			# Vado indietro di 1

	j	storeCicle

offset:
	add	$a3, $a3, $s0
	addi	$a1, $a1, 1
	addi	$t0, $t0, 1
	add	$t5, $t5, $s0
	
	j	positions

end:
	jr	$ra