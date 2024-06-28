.include "linkedlist_struct.s"
.section .text

.equ EXIT_CODE_HEAD_NULL, -1
.equ EXIT_CODE_OUT_OF_MEMORY, 137 # https://refine.dev/blog/kubernetes-exit-code-137/

# Function: linkedlist_push
# input> a0: head, a1: value
# output< a0: head or -1 if error
.globl linkedlist_push
linkedlist_push:
    # Decrement the stack pointer to store 3 registers. Given that in riscv64
    # each register is 8 bytes long, we need 24 bytes of memory on the stack.
	addi sp, sp, -24
	sd ra, 16(sp)
	# current head of the linked list
	sd a0, 8(sp)
	# value to store in the node we are about to push to the linked list
	sd a1, 0(sp)

	# Try allocating `node_size` bytes of memory on the heap using malloc.
	li a0, node_size
	call malloc
	# malloc returns NULL if it wasn't able to allocate heap memory
	beqz a0, handle_malloc_failure

	# value
	ld t1, 0(sp)
	sd t1, node_offset_value(a0)

	# insert as new head head
	ld t0, 8(sp)
	sd t0, node_offset_next(a0)

	j linkedlist_push_epilogue

handle_malloc_failure:
	li a0, EXIT_CODE_OUT_OF_MEMORY

linkedlist_push_epilogue:
	ld ra, 16(sp)
	addi sp, sp, 24
	ret

# Function: linkedlist_pop
# input> a0: head
# output< a0: head, a1: value
.globl linkedlist_pop
linkedlist_pop:
	addi sp, sp, -node_size
	sd ra, 8(sp)
	sd s0, 0(sp)
	beqz a0, handle_head_null

	# a1 <- value of the node we are about to pop
	ld a1, node_offset_value(a0)
	# s0 <- pointer to next node (will be new head)
	ld s0, node_offset_next(a0)

    # free the memory pointed by a0 (i.e. head before popping this node)
	call free

	# assign the new head (i.e. head after having popped this node)
	mv a0, s0
	j linkedlist_pop_epilogue

handle_head_null:
    li a0, EXIT_CODE_HEAD_NULL

linkedlist_pop_epilogue:
	ld s0, 0(sp)
	ld ra, 8(sp)
	addi sp, sp, node_size
	ret

# Function: linkedlist_print
# input> a0: head
.globl linkedlist_print
linkedlist_print:
	addi sp, sp, -24
	sd ra, 16(sp)
	sd a0, 8(sp)
	sd a0, 0(sp)

linkedlist_print_loop:
	beqz a0, linkedlist_print_epilogue

	sd a0, 0(sp)
	ld a1, node_offset_value(a0)
	la a0, linkedlist_prompt
	call printf

	ld a0, 0(sp)
	ld a0, node_offset_next(a0)
	j linkedlist_print_loop

linkedlist_print_epilogue:
	ld a0, 8(sp)
	ld ra, 16(sp)
	addi sp, sp, 24
	ret

.section .rodata
linkedlist_prompt: 
	.asciz "node value: %u \n"
    