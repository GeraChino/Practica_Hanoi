# Gerardo de Jesus Cruz Plazola
# Saul Antonio Rodriguez Lillington
.data

.text

addi $s1, $zero, 0x10010000	# Mandamos direccion de Torre A a registro s1.
addi $s2, $zero, 0x10010020	# Mandamos direccion de Torre B a registro s2.
addi $s3, $zero, 0x10010040	# Mandamos direccion de Torre C a registro s3.
addi $s0, $zero, 3		# Numero de discos.
addi $t0, $zero, 1		# Variable comparativa para el ciclo.
add $v0, $s0, $zero		# Variable auxiliar que contiene el numero de discos.

RellenadoDeDiscos:

	sw $v0, 0($s1)				# Cargamos el numero de discos en la Torre A ($s1).
	add $v0, $v0, -1			# Decrementamos el numero de discos.
	add $s1, $s1, 4				# Sumamos 4 al offset de la direccion de s1.
	bne $v0, $zero, RellenadoDeDiscos	# Comparacion. Si el numero de discos es igual a cero, brinca a la siguiente instruccion.
	jal RellenadoCompleto			# Brinca a la etiqueta RellenadoCompleto.
	
RellenadoCompleto:

	jal Hanoi		# Brinco a la etiqueta Hanoi donde se desarrolla el algoritmo.
	jal Exit		# Brinco a la etiqueta Exit donde termina el programa.
	
Hanoi:

	add $sp, $sp, -8	# Decrementamos stack pointer para poder guardar el numero de discos y $ra.
	sw $s0, 4($sp)		# Guardamos el valor del numero de discos en el stack pointer.
	sw $ra, 0($sp)		# Guardamos el valor del Return Address en el stack pointer.
	beq $s0, $t0, CasoBase 	# Comparamos. Si $s0 y $t0 son iguales, brinca al caso base.
	jal PrimeraLlamada	# En caso de que la comparacion falle, brincara a la primera llamada.

CasoBase:
	
	add $s1, $s1, -4		# Restamos 4 a la direccion de la Torre origen.
	lw $t3, 0($s1)			# Cargara el valor de la Torre en $t3.
	sw $zero, 0($s1)		# Limpiamos la Torre con un 0.
	sw $t3, 0($s3)			# Guardamos el valor que esta en $t3 en la Torre destino. Termina el intercambio.
	add $s3, $s3, 4	       	 	# Sumamos 4 a la direccion de la Torre destino.
	
	bne $t4, $zero, SegundaLlamada  # Si $t4 es diferente de cero, entonces brincara a la SegundaLlamada
	lw $ra, 0($sp)			# Cargamos el valor del return address desde el stack pointer.
	addi $sp, $sp, 8		# Sumamos 8 al stack pointer.
	jr $ra				# Brincamos al return address.
	
PrimeraLlamada:

	add $s0, $s0, -1		# Restamos el numero de discos - 1 siguiendo el algoritmo.
	add $t2, $s2, $zero		# Guardamos en temporal $t2 lo que esta en $s2.
	add $s2, $s3, $zero		# Primera parte del intercambio.
	add $s3, $t2, $zero		# Segunda parte del intercambio.
	jal Hanoi			# Brincamos a la etiqueta Hanoi. 
	      
	add $t4, $t4, $t0		# Temporal que indica cuando se esta en la recursion. 
	add $t2, $s2, $zero		# Guardamos en temporal $t2 lo que esta en $s2.
	add $s2, $s3, $zero		# Primera parte del intercambio. 
	add $s3,$t2,$zero		# Segunda parte del intercambio. 
    	jal CasoBase  			# Brincamos al caso base (donde hacemos los intercambios).
	       
SegundaLlamada:

	add $t4,$zero,$zero	# Hacemos 0 $t4 para indicar que no hay recursion.
	
    	lw $s0, 4($sp)		# Cargamos el valor del disco.
     	addi $s0, $s0, -1	# Le restamos 1 al numero de discos. 
	add $t2,$s1,$zero	# Guardar en temporal $t2 lo que esta en $s1.
	add $s1,$s2,$zero	# Primera parte del intercambio. 
	add $s2,$t2,$zero	# Segunda parte del intercambio.
	jal Hanoi		# Brincamos a la etiqueta Hanoi. 
	       
	lw $ra, 0($sp)		# Cargamos el valor del return address desde el stack pointer. 
	add $t2,$s1,$zero	# guardar en temporal $t2 lo que esta en $s1.
	add $s1,$s2,$zero	# Primera parte del intercambio. 
	add $s2,$t2,$zero	# Segunda parte del intercambio. 
    	addi $sp, $sp, 8	# Sumamos 8 al stack pointer.
    	jr $ra			# Brincamos al valor del return address.
	
Exit:
	
