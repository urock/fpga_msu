import serial
import sys 
import struct

def write_reg(ser, addr, value):
   wr_cmd = 1
   bs = struct.pack('B',wr_cmd) + struct.pack('B',addr) + struct.pack('>I',value)
   ser.write(bs)
   
def read_reg(ser, addr):
   rd_cmd = 2
   bs = struct.pack('B',rd_cmd) + struct.pack('B',addr)
   ser.write(bs)  
   read_bytes = ser.read(4)
   if (len(read_bytes) != 4 ):
      print("Error reading from UART\n")
      return False
   return struct.unpack('>I', read_bytes)[0]

def main():

   dev = sys.argv[1]
   
   cmd = sys.argv[2]
   
   if (cmd != "rd") and (cmd != "wr"):
      print("Bad command")
      return False
      
   addr = int(sys.argv[3])
     
   ser = serial.Serial(
       port=dev,
       baudrate=115200,
       timeout=1
   )

   ser.isOpen()
      
   if (cmd == "wr"):
      wr_val = int(sys.argv[4])
      print("Writting @{} reg -> {}".format(addr, wr_val))
      write_reg(ser, addr, wr_val)
      
   if (cmd == "rd"):
      reg_val = read_reg(ser, addr)
      if (reg_val != False):
         print("Read Val -> {}".format(reg_val))

   
   ser.close()

if __name__ == "__main__":
    # execute only if run as a script
    main()


