import serial

ser = serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=115200,
    timeout=1
)

ser.close()
ser.open()
ser.isOpen()

print("Initializing the device ..")

ser.write(bytes([2]))

b = ser.read()

print("Read Val = {}".format(b))



