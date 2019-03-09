.data
.align 2
bufferToWrite :	  .space 1024 
array :	  	  .word  10 24 5 7 
writeTo:	  .asciiz ".marSETUP/messaggioDecifrato.txt"

.text
	   move $t1, $zero		#init index
readData:  lw   $t3, arra($t1)
	   	
	   li   $v0,14    		# chiamata di sistema per leggere
	   move $a0,$t6  		# specifico il percorso da dove leggere
	   la   $a1,bufferToWrite 	# carico l'indirizzo di PARTENZA del buffer
	   li   $a2,1024
	   syscall 


main: 	   li   $v0,13			# chiamata di sistema per apertura files
	   la   $a0,writeTo
	   li   $a1,1			#modalita di apertura (solo lettura)
	   li   $a2,0	
	   syscall 
	   move $t6,$v0   		# 


	   
printFile: li   $v0,4			# STAMPA l'intero buffer
	   la	$a0,bufferReader	# chiamata di sistema per stampare
	   syscall 
	   
						   	   	    	   	    	   	   
closefile: li   $v0,16
	   move $a0,$t6
	   syscall 

closeProg: li $v0,10
	   syscall  

 
