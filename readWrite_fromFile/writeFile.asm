# Esempio di scrittura in un file. 
.data
filePath:   .asciiz   ".marSETUP/prova.txt"	
text: 	    .asciiz   "Hello World!" 

.text
.globl main

 			
 main: 			  # apri file ( siccome non esiste lo crea
      li $v0,13           # chiamata di systema per aprire
      la $a0,filePath     # carica il percorso di scrittura
      li $a1,1            # flag di scrittura
      syscall
      move $s6,$v0        # salvo il percorso 

    #scrivo nel file la stringa
    li $v0, 15              # chiamata di sistema
    move $a0, $s6          # pass il percorso dove scrivere
    la $a1, text      	   # passa inidirizzo di inizio della stringa
    li $a2, 12              # size del buffer
    syscall

close:  li	$v0, 16		# Close File Syscall
	syscall
	

