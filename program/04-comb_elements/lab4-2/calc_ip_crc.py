from scapy.all import *

iph = IP(src = '128.64.32.1', dst = '128.64.33.2')

hexdump(iph)

iph.show2()

iph_b = bytes(iph)

print('crc1 -> ' + hex((iph_b[10])))
print('crc2 -> ' + hex((iph_b[11])))
print('crc1 -> {0:08b}'.format(iph_b[10]))
print('crc1 -> {0:08b}'.format(iph_b[11]))

ftxt = open('ip_header.txt', 'w')

i = 0
for b in iph_b:
    if (i!=0):
        ftxt.write("\n")
    bin_b = "{0:08b}".format(b)
    ftxt.write(bin_b)
    i += 1


ftxt.close()

# f_txt = open('ip_header.txt', 'w')
# fbin = open('ip_header.bin', 'wb')
# fbin2 = open('ip_header.bin', 'wb')
#
# # [fbin.write(b) for b in iph_b]
#
# newFileByteArray = bytearray(iph_b)
# fbin2.write(newFileByteArray)
#
# # fbin.close()
# fbin2.close()

