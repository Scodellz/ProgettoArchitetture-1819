.data
	inputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/input.txt"
	outputFile:	.asciiz			"C:/Users/duxom/Desktop/Mars/output.txt"
	bufferReader:	.space	1500
	supportBuffer:	.space	1500
	
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

decryption_E:					# Inizio del metodo che decifra secondo l'algoritmo E
	move	$t5, $zero			# $t5 conta gli elementi inseriti
	li	$s1, 10				# $t1 e' la costante che servira' per formare le posizioni
						# superiori al 9
						
itemToPlace:					# Metodo che trova l'elemento da piazzare
	la	$a2, supportBuffer		# Imposto l'indirizzo iniziale del buffer di supporto in $a2
	lbu	$t0, ($a1)			# Carico il primo elemento della frase in $t0 (che sara' l'elemento
						# che dovrà essere inserito per formare la frase originaria)
	addi	$a1, $a1, 2			# Scorro avanti di 2 dato che dopo questo elemento ci sara'
						# sicuramente '-'
	move	$t1, $zero			# Inizializzo la variabile che formera' la posizione
	
findPos:						# Ciclo che trova la posizione in cui piazzare l'elemento
	lbu	$t2, ($a1)			# Carico l'elemento puntato in $t2
	beq	$t2, '-', placeItem		# Se tale elemento e' '-'
	beq	$t2, ' ', placeItem		# O uno spazio
	beqz	$t2, placeItem			# Oppure la fine della stringa
						# Allora ho trovato la posizione giusta dove collocare l'elemento
	mult	$t1, $s1				# Altrimenti vuol dire che la posizione non e' completa
	mflo	$t1				# Salvo il risultato della moltiplicazione di $t1 per 10 in $t1
	addi	$t2, $t2, -48			# Converto l'elemento da ASCII a numero
	add	$t1, $t1, $t2			# Sommo la cifra per formare la posizione
	addi	$a1, $a1, 1			# Scorro di 1 il buffer
	
	j	findPos				# Ricomincio il ciclo
	
placeItem:					# Metodo che piazza l'elemento una volta trovata la sua posizione
	add	$a2, $a2, $t1			# Mi sposto alla posizione indicata
	sb	$t0, 0($a2)			# Inserisco l'elemento in posizione corretta
	addi	$t5, $t5, 1			# Dato che ho inserit un elemento aumento il contatore di 1
	addi	$a1, $a1, 1			# Avanzo di 1 sul buffer
	beq	$t2, ' ', itemToPlace		# Se prima ho trovato uno spazio allora devo trovare
						# il prossimo elemento da piazzare 
	la 	$a2, supportBuffer		# Se invece ho trovato un '-' significa che devo piazzare l'elemento
						# altre volte, torno quindi all'inizio del buffer decodificato
	move	$t1, $zero			# Metto nuovamente a 0 il contatore delle posizioni
	beq	$t2, '-', findPos		# E torno al metodo che trova le posizioni
						# ALTRIMENTI VUOL DIRE CHE SONO ARRIVATO ALLA FINE DELLA STRINGA
						# E IL PROGRAMMA PUO' TERMINARE!!

print:						# Stampa su file di output
	li	$v0, 13				# Apertura File
	la	$a0, outputFile			# Carico il file di output
        li 	$a1, 1            		# Flag di scrittura (1)
        li 	$a2, 0				# (ignorato)
	syscall
	
	move	$t1, $v0				# Salvo il descrittore del file in $t1

	li	$v0, 15				# Scrittura nel file
	move	$a0, $t1    			# Carico il descrittore del file in $a0
	la	$a1, supportBuffer		# Carico il buffer di output
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
	li	$v0, 10
	syscall
