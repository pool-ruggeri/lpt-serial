# Import serial package
import serial

# Set up port
port = serial.Serial("/dev/ttyUSB0", baudrate=115200)

# Create dictionary to define conditions
# This is optional but convenient
condition_dict = {'low' : 10, 'high': 255}

# Assume that we are in condition "low" and want to send a trigger.
nowcond = condition_dict['low']

# Define trigger as int
# Note: With int(), nowcond could be a string such as "1" or "255"
trigger = int(nowcond)

# turn integer into binary
# https://www.geeksforgeeks.org/how-to-co ... in-python/
port.write(trigger.to_bytes(1, 'big'))
# '1' to get 1 byte
# byte starts from the right
# 'big' because higher bit is to the left

port.close()