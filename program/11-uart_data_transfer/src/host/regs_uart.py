import serial

ser = serial.Serial(
    port='COM3',
    baudrate=115200,
    timeout=1
)

ser.close()
ser.open()
ser.isOpen()

print("Initializing the device ..")

ser.write(bytes([12]))

b = ser.read()

print("Read Val = {}".format(b))



