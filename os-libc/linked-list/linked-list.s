.section .data
format:
    .string "%d\n"
head:
    # Pointer to the first node. This might change when we insert new nodes, so
    # we store it in the .data section (instead of the .rodata section).
    # Note: a word of memory in RISC-V is always 32 bits wide, even on 64-bit RISC-V.
    .word 0


.section .text
.globl main
.equ EXIT, 93 # Linux exit syscall
.equ EXIT_CODE_SUCCESS, 0
.equ EXIT_CODE_OUT_OF_MEMORY, 137 # https://refine.dev/blog/kubernetes-exit-code-137/

# Function: create_node
# Arguments: a0 = data
# Returns: a0 = pointer to the newly created node
create_node:
    # We allocate 8 bytes for each node (in RISC-V 1 word is 4 bytes):
    # 4 bytes for the node's data
    # 4 bytes for the pointer to the next node
    li a1, 8
    call malloc

    # malloc returns NULL if it wasn't able to allocate heap memory
    beqz a0, handle_malloc_failure

    # Store in t0 the pointer to this newly created node
    mv t0, a0

    # 1st word of heap memory: node's data
    sw a0, 0(t0)

    # 2nd word of heap memory: NULL pointer for the next node
    li a1, 0
    sw a1, 4(t0)

    # Return the pointer to this newly created node
    mv a0, t0
    ret

# Function: insert_head
# Arguments: a0 = data
insert_at_head_old:
    # Create a new node with the data currently stored in a0
    call create_node

    # Load the current head pointer into t1
    lw t1, head
    # Set the new node's next pointer (4(a0)) to the current head (t1)
    sw t1, 4(a0)


    la t2, head # Load address of head into t2
    sw a0, 0(t2) # Store the value in a0 (address of new node) at head
    ret

insert_at_head:
    jal ra, create_node
    mv t1, a0 # t1 = pointer to new node

    ld t2, 4(s0) # t2 = current head of the list
    sd t2, 4(t1) # new node's next = current head

    mv s0, t1 # Update head to new node
    mv a0, s0 # Return new head
    ret

# Function: traverse_list
# Arguments: s0 = head of the list
# Prints each node's data
traverse_list:
    mv t0, s0                # t0 = current node

traverse_loop:
    beqz t0, traverse_end    # If current node is NULL, end traversal

    ld a0, 0(t0)             # Load node's data into a0
    la a1, format            # Load address of format string
    jal ra, printf           # Call printf to print data

    ld t0, 8(t0)             # Move to next node
    j traverse_loop          # Repeat

traverse_end:
    ret

# Function: free_list
# Arguments: s0 = head of the list
# Frees each node's memory
free_list:
    mv t0, s0                # t0 = current node

free_loop:
    beqz t0, free_end        # If current node is NULL, end loop

    ld t1, 8(t0)             # t1 = next node
    mv a0, t0                # a0 = current node
    jal ra, free             # Call free to deallocate current node

    mv t0, t1                # Move to next node
    j free_loop              # Repeat

free_end:
    ret

handle_malloc_failure:
    li a0, EXIT_CODE_OUT_OF_MEMORY
    ret

main:
    # Initialize list head to NULL
    la t0, head
    sd a0, 0(t0)

    # Example: Create a list with three nodes containing values 1, 2, 3
    li a0, 1
    call create_node
    mv s0, a0

    li a0, 2
    call insert_at_head

    li a0, 3
    call insert_at_head

    call traverse_list
    call free_list

    li a0, EXIT_CODE_SUCCESS
    li a7, EXIT
    ecall
    # ret # Return to the caller
