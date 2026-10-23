board = [
    "00000000",
    "00000000",
    "00000000",
    "01110000",
    "00000000",
    "00000000",
    "00000000",
    "00000000"
]

bitstring = "".join(board)
print(len(bitstring))

hexstring = ""

for i in range(0, len(bitstring), 4):
    # print(f"{i}, {i + 3}")
    # print(bitstring[i:i+4])
    # print(hex(int(bitstring[i:i+4])))
    hex_number = str(hex(int(bitstring[i:i+4], 2)))
    hexstring += hex_number[2:3]
    # print(hex_number[2:3])

print(hexstring)
# print(hex(int(bitstring, 2)))
# board_hex = [(hexstring[i:i+n]) for i in range(0, len(hexstring), n)]
with open("gamestate.txt", "w") as f:
    f.write(hexstring)

