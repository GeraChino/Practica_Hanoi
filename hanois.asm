# Saúl Antonio Rodríguez Lillingston
# Gerardo Cruz Plazola	
# Práctica 1 - Torres de Hanoi

.data
		
.text
	addi $a0, $zero, 0x10008000 	#dirección de memoria de torre 1
#--------------------------offset para reservar memoria dinámica-------------------------
	addi $s1, $zero, 3 		# número de discos
	add $s2, $zero, $s1 		# num de discos para salida de recursión
	sll $s3, $s1, 2   		# num de discos multiplicado por 4, offset
#-------------------------Dirección de memoria del resto de las torres-------------------
	add $a1, $a0, $s3 		#dirección de memoria de torre 2
	add $a2, $a1, $s3		#dirección de memoria de torre 3
	addi $a1, $a1, 4		#primera dirección torre 2
	addi $a2, $a2, 4		#first direction in tower 3
#------------------------- variables de rellenado----------------------------------------
	add $s0, $zero, $s1		#discos a rellenar
	
#-------------------------Rellenado de discos--------------------------------------------
rellenadoDeDiscos:
	sw $s0, 0($a0)
	addi $a0, $a0, 4
	addi $s0, $s0, -1
	bne $s0, $zero , rellenadoDeDiscos	#comparación entre contador y num de discos+1
#----------------------------------------------------------------------------------------
main:
	jal Hanoi
	j exit
	
Hanoi:
	beq $s1, 1, CasoBase 		#verificación de caseo base, discos = 1
	addi $sp, $sp, -20		#offset para variables de recursión
#-----------------------guarda variables de recursión en el stack-------------------------	
	sw $a0, 0($sp) 			#torre origen
	sw $a1, 4($sp)			#torre auxiliar
	sw $a2, 8($sp)			#torre final
	sw $ra, 12($sp)			#return address	
	sw $s1, 16($sp)			#discos en el caso
#-----------------------------------------------------------------------------------------
	add $t7, $a1, $zero		#se voltean las torres del paso 1
	add $a1, $a2, $zero
	add $a2, $t7, $zero
	
	subi $s1, $s1, 1 		#resta uno a los discos
	jal Hanoi
#---------------------------brinco de regreso de movimiento de discos para paso 2---------
	addi $sp, $sp, 20
	lw $a0, 0($sp) 			#torre origen
	lw $a1, 4($sp)			#torre auxiliar
	lw $a2, 8($sp)			#torre final

# Number of discs and return address ($ra) won't load as variables just yet, to correctly
# execute step-2 
#-----------------------------------------Step 2-------------------------------------------
	jal Hanoi
#-----------------------------------------Step 3-------------------------------------------
	lw $ra, 12($sp)			#return address	
	lw $s1, 16($sp)			#number of discs 
	
# Time to flip the towers for step 3
	add $t7, $a0, $zero
	add $a0, $a1, $zero
	add $a1, $t7, $zero
	add $t7, $a1, $zero
	add $a1, $a2, $zero
	add $a2, $t7, $zero
	jal Hanoi
	addi $sp, $sp, 20		#return stack pointer to a right position
		
CasoBase:
	addi $a0, $a0, -4		#puntero a última posición de memoria
	lw $t9, 0($a0)			#saca disco de torre origen
	sw $zero, 0($a0)
	addi $a2, $a2, -4		#puntero a última posición de memoria
	sw $t9, 0($a2)
	
	addi $a0, $a0, 4		#se regresa la dirección al tope de cada torre
	addi $a2, $a2, 4		#--------------------------------------------------
	jr $ra

exit:
	
	
	

	
	
