# Time access and conversions
import time

# Control measurement devices
import visa


# Create resource manager
rm = visa.ResourceManager()

## FPGA
# Connect to the FPGA
fpga = rm.open_resource('ASRL5::INSTR')

# Query identification string
fpga_idn = fpga.query('*IDN?')

# Check identification string
if fpga_idn != 'IDLAB,AETHER,0.1,0.1\r\r\n':
    print('Check the connection to the FPGA!')
else:
    print('Successfully connected to the FPGA.')

## Oscilloscope
# Connect to the oscilloscope
oscilloscope = rm.open_resource('GPIB0::8::INSTR')

# Query identification string
oscilloscope_idn = oscilloscope.query('*IDN?')

# Check identification string
if oscilloscope_idn != 'Agilent Technologies,86100C,MY43490120,A.09.01\n':
    print('Check the connection to the oscilloscope!')
else:
    print('Successfully connected to the oscilloscope.')

# Define measurement
oscilloscope.write(':MEASURE:DEFINE DELTATIME, RISING, 1, MIDDLE, RISING, 1, MIDDLE')
oscilloscope.write(':SYSTEM:HEADER OFF')

# Reset
fpga.write('TRANSCEIVERS:RESET')

time.sleep(2)

# Select channel
fpga.write('TRANSCEIVERS:SELECT OUTPUT5')

# This is large in terms of us...
deltatime = 1

while abs(deltatime) > 1e-12:
    if deltatime > 0:
        # Decrement phase
        fpga.write('TRANSCEIVERS:PHASE -1')
    else:
        # Increment phase
        fpga.write('TRANSCEIVERS:PHASE 1')

    deltatime = float(oscilloscope.query(':MEASURE:DELTATIME? CHANNEL3,CHANNEL4'))

    time.sleep(0.05)

