.include "macros.asm"
.data
	menuInicial: .asciiz " Calculo (C) ou memoria (M)\n"
	menuSec1:    .asciiz "Adicao (+)\nSubtracao (-)\nDivisao (/)\nMultiplicacao (*)\nPotenciacao (^)\nRaiz quadrada (R)\nTabuada de 1 numero fornecido (T)\nFatorial de 1 numero fornecido (!)\nCalculo da sequencia de Fibonacci dado um intervalo (F)\n"
	menuSec2:    .asciiz "Memoria 1 (M1), Memoria 2 (M2), Memoria 3 (M3)\n"
	div0:	     .asciiz "Divisao por zero nao existe, digite outro valor\n"
	op:	     .space  2
	n1:	     .asciiz "primeiro numero\n"
	n2:	     .asciiz "segundo numero\n"
	n: 	     .asciiz "Numero\n"
	newline:	     .asciiz "\n"
	vazio:		.asciiz "Essa memoria esta vazia\n"
	space:		.asciiz " "
	#adi:	     .byte   '+'
	#sinal $s7
	#numeros da operacao $s5 $s6
	#resultado $s0
.text

main:
	
	li $v0, 4 # set syscall para print
	la $a0, menuInicial
	syscall 
	
	li $v0, 8 # set syscall para receber string
	li $a1, 2 # set numero maximo de bytes a serem lidos p/ 2
	la $a0, op # coloca o enderco de op em $a0
	syscall
	
	li $v0, 4 # set syscall para print
	la $a0, newline
	syscall
	
	j selecao
	#lbu $t1, adi
	#li  $t0, '+'
	#beq $t1, $t0, printf
	
exit:
	li $v0, 10
	syscall
	
selecao:
	lbu $t1, op
	li $t0, 'C'
	beq $t1, $t0, calculo
	
	lbu $t1, op
	li $t0, 'M'
	bne $t1, $t0, exit
	beq $t1, $t0, memoria
	
	j main
	
calculo:
	li $v0, 4 # set syscall para print
	la $a0, menuSec1
	syscall
	
	li $v0, 8
	la $a0, op
	li $a1, 2
	syscall
	
	li $v0, 4 # set syscall para print
	la $a0, newline
	syscall
	
	lbu $s7, op
	beq $s7, '+', numeros1
	beq $s7, '-', numeros1
	beq $s7, '/', numeros1
	beq $s7, '*', numeros1
	beq $s7, '^', numero
	beq $s7, 'R', numero
	beq $s7, 'T', numero
	beq $s7, '!', numero
	beq $s7, 'F', numeros1
	
numeros1:
	li $v0, 4 # set syscall para print
	la $a0, n1
	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
   
numeros2:
	li $v0, 4 # set syscall para print
	la $a0, n2
	syscall
	
	li $v0, 5
	syscall
	
	move $s5, $v0
	jal checkdiv0
	beq $s7, '+', adicao
	beq $s7, '-', subtracao
	beq $s7, '/', divisao
	beq $s7, '*', multiplicacao
	beq $s7, 'F', fibonacci_intervalo
   
checkdiv0:
	bne $s7, '/', endfunction
	bne $s5, $zero, endfunction
	li $v0, 4 # set syscall para print
	la $a0, div0
	syscall
	j numeros2   
	
adicao:
	add $s0, $s5, $s6
	j endcalculo

subtracao:
	sub $s0,$s5,$s6
	j endcalculo

divisao:
	div $s0,$s5,$s6
	j endcalculo

multiplicacao:
	mul $s0,$s5,$s6
	j endcalculo

fibonacci_intervalo:
	move $t0,$s5
	move $t1,$s6
	addi $sp,$sp,-4
	sw $ra, 0($sp)

	fibo_loop:
		beq $t0,$t1,endfibo
		move $a0,$t0
		jal fibonacci
		move $t3,$v0
		print_int($t3)
		print_str_memo(space)
		addi $t0,$t0,1
		j fibo_loop




fibonacci:
	subu $sp,$sp,12
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	
	# caso base
	li $v0,1
	blt $a0,0x2,fib_fim
	
	move $s0,$a0
	
	subu $a0,$s0,1
	jal fibonacci
	move $s1,$v0
		
	subu $a0,$s0,2
	jal fibonacci

	add $v0,$v0,$s1
	
	fib_fim:
		lw $ra,0($sp)
		lw $s0,4($sp)
		lw $s1,8($sp)
		add $sp,$sp,12
		jr $ra
	
endfibo:
	lw $ra,0($sp)
	add $sp,$sp,4
	jr $ra

   
endcalculo:
	#armazenamento na memoria
	#Colocando o return adress na stack
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	addi $sp, $sp, 28
	
	jal guardarMemoria
	
	#Restaurando o return adress
	addi $sp, $sp, -28
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	
	li $v0, 1
	la $a0, ($s0) #resultado
	syscall
	
	li $v0, 4 # set syscall para print
	la $a0, newline
	syscall
	
	j main
	
numero:
	li $v0, 4 # set syscall para print
	la $a0, n
	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
	beq $s7, '^', potenciacao
	beq $s7, 'R', raiz
	beq $s7, 'T', tabuada
	beq $s7, '!', fatorial
	
potenciacao:
	# s5^s6
	addi $s0,$zero,1

	potenciacao_recursao:
		beq $s6, $zero, endcalculo # se s6 = 1 termina a recursao
		mul $s0, $s0, $s5 # s0 = s0*s5
		addi $s6, $s6, -1 # s6 = s6-1
		j potenciacao_recursao
   
raiz:
	move  $s0, $zero        # incializa o retorn
	move  $t1, $s5          # copia o argumento pra t1

	addi  $t0, $zero, 1
	sll   $t0, $t0, 30		#coloca em t0 no trigezimo bit 1     
	
	j raiz_bit

	raiz_bit:
		slt   $t2, $t1, $t0     # if( n < bit): 
		beq   $t2, $zero, raiz_loop

		srl   $t0, $t0, 2       # shifta o bit para direita
		j     raiz_bit

	raiz_loop:
		beq   $t0, $zero, endfunction

		add   $t3, $s0, $t0
		slt   $t2, $t1, $t3
		beq   $t2, $zero, raiz_else

		srl   $s0, $s0, 1
		j     raiz_loop_end

	raiz_else:
		sub   $t1, $t1, $t3
		srl   $s0, $s0, 1
		add   $s0, $s0, $t0

	raiz_loop_end:
		srl   $t0, $t0, 2
		j     raiz_loop


   
tabuada:
	addi $t0,$zero,1
	addi $t1,$zero,10

	loop_tabuada:
		bgt $t0,$t1,endfunction	
		mul $t0,$s5,$t0 # t0 = s*t0
		addi $t0,$t0,1 # t0++
		print_int($t0)
		print_str_memo(newline)
		j tabuada
fatorial:
	move $a0, $s6 # coloca o operando em $a0
	addi $a1, $a0, -1 # coloca o operando-1 em $a1
	addi $a2, $zero, 1 # coloca zero em a2
	
	jal fatorial_recursao
	move $s0,$a0
	j endcalculo
	
fatorial_recursao:
	beq $a1, $a2, endfunction # se a1 = 0 termina a recurs�o
	mul $a0, $a0, $a1 # a0 = a0*a1
	addi $a1, $a1, -1 # a1 = a1-1
	j fatorial_recursao
   
memoria:
   	li $v0, 4 # Print do menu secundario
	la $a0, menuSec2
	syscall
	
	li $v0, 8 #Recebendo o texto de qual memoria acessar
	la $a0, mem
	li $a1, 3
	syscall
	
	li $v0, 4 # Print de nova linha
	la $a0, newline
	syscall
	
	#Determianando qual mem�ria o usuario quer acessar
	addi $t0, $zero, 0
	lbu $s4, mem($t0)
	bne $s4, 'M', main
	addi $t0, $t0, 1
	lbu $s4, mem($t0)
	beq $s4, '1', pegarM1
	beq $s4, '2', pegarM2
	beq $s4, '3', pegarM3
	
guardarMemoria:
	#Subtrai o ponteiro para chegar no ponto em que cabem 3 argumentos
	addi $sp, $sp, -24
	#Transfencia dos valores antigos para outras memorias M2->M3, M1->M2
	lw $t0, 4($sp)
	sw $t0, 8($sp)
	
	lw $t0, 0($sp)
	sw $t0, 4($sp)
	
	#Guarda na stack na posi��o 0 a M1
	sw $s0, 0($sp)
	#Volta o ponteiro para o estado inicial
	addi $sp, $sp, 24
	
	jr $ra
	
pegarM1:
	#Subtrai o ponteiro para chegar no ponto da primeira memmoria
	addi $sp, $sp, -24
	#Passa o valor para $t1
	lw $t1, 0($sp)
	addi $sp, $sp, 24
	#Compara se a memoria eh vazia
	beq $t1, $zero, memoriaVazia
	
	#Print valor
	li $v0, 1
	move $a0, $t1
	syscall
	
	#Print  linha
	li $v0, 4
	la $a0, newline
	syscall
		

	
	jal main
		
pegarM2:
	#Subtrai o ponteiro para chegar no ponto da segunda memoria
	addi $sp, $sp, -20
	#Passa o valor para $t1
	lw $t1, 0($sp)
	addi $sp, $sp, 20
	#Compara se a memoria eh vazia
	beq $t1, $zero, memoriaVazia
	
	#Print valor
	li $v0, 1
	move $a0, $t1
	syscall
	
	#Print linha
	li $v0, 4
	la $a0, newline
	syscall
	
		
	jal main
	
pegarM3:
	#Subtrai o ponteiro para chegar no ponto da terceira memoria
	addi $sp, $sp, -16
	#Passa o valor para $t1
	lw $t1, 0($sp)
	addi $sp, $sp, 16
	#Cinoara se a memoria eh vazia
	beq $t1, $zero, memoriaVazia
	
	#Print memoria vazia
	li $v0, 1
	move $a0, $t1
	syscall
	
	#Print linha
	li $v0, 4
	la $a0, newline
	syscall
	
	jal main
	
memoriaVazia:
	#Print frase
	li $v0, 4
	la $a0, vazio
	syscall
	
	jal main
   
endfunction:
	jr $ra
