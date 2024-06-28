const std = @import("std");

const L = std.SinglyLinkedList(u32);

fn printList(list: *L, writer: anytype) !void {
    try writer.print("Linked list: [", .{});
    // traverse the linked list forward and print each element
    // https://github.com/ziglang/zig/blob/cb308ba3ac2d7e3735d1cb42ef085edb1e6db723/lib/std/linked_list.zig#L149
    var it = list.first;
    while (it) |node| : (it = node.next) {
        try writer.print(" {d}", .{node.data});
    }
    try writer.print("]\n", .{});
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var list = L{};

    var one = L.Node{ .data = 1 };
    var two = L.Node{ .data = 2 };
    var three = L.Node{ .data = 3 };
    var four = L.Node{ .data = 4 };
    var five = L.Node{ .data = 5 };

    list.prepend(&two); // {2}
    two.insertAfter(&five); // {2, 5}
    list.prepend(&one); // {1, 2, 5}
    two.insertAfter(&three); // {1, 2, 3, 5}
    three.insertAfter(&four); // {1, 2, 3, 4, 5}

    try printList(&list, stdout);
}
