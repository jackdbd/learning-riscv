.section .data
    format: .string "%d\n"

.section .bss
    .lcomm head, 8 # Allocate space for the head pointer (8 bytes for 64-bit address)

.section .text
.global main
.equ EXIT, 93 # Linux exit syscall
# .extern free
# .extern malloc
# .extern printf

main:
    # Initialize list head to NULL
    la t0, head
    sd x0, 0(t0)

    # Example: Create a list with three nodes containing values 1, 2, 3
    li a0, 1
    jal ra, create_node      # Create first node
    mv s0, a0                # s0 holds the head of the list

    li a0, 2
    jal ra, insert_at_head   # Insert second node at head

    li a0, 3
    jal ra, insert_at_head   # Insert third node at head

    jal ra, traverse_list    # Traverse and print the list

    jal ra, free_list        # Free the list memory

    li a7, EXIT
    ecall

# Function: insert_at_head
# Arguments: a0 = data
# Returns: a0 = new head of the list
insert_at_head:
    jal ra, create_node      # Create new node
    mv t1, a0                # t1 = pointer to new node

    ld t2, 8(s0)             # t2 = current head of the list
    sd t2, 8(t1)             # new node's next = current head

    mv s0, t1                # Update head to new node
    mv a0, s0                # Return new head
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
