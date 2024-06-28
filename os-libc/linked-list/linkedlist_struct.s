# In riscv64 each register is 8 bytes long (i.e. 64 bit).
# We store the node's value in one register, and the pointer to the next node in
# another register. Therefore, we need 16 bytes of memory for each node.
# This memory will be allocated on the heap (e.g. with malloc), since we need to
# be able to grow the linked list dinamically.
.equ node_size, 16

# byte offset to value
.equ node_offset_value, 0

# offset to pointer (address) of next element
.equ node_offset_next, 8
