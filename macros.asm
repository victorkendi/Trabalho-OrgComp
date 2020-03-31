.macro quit
	li $v0, 10
	syscall 
.end_macro

.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

.macro print_str_memo (%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro 