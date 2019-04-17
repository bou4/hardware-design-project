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

## Multimeter
# Connect to the multimeter
multimeter = rm.open_resource('GPIB0::4::INSTR')

# Query identification string
multimeter_idn = multimeter.query('*IDN?')

# Check identification string
if multimeter_idn != 'HEWLETT-PACKARD,34401A,0,11-5-2\n':
    print('Check the connection to the multimeter!')
else:
    print('Successfully connected to the multimeter.')

file = open(time.strftime('%H-%M-%S.txt'), 'w')

DELTATIME = []

VOLTAGE = []

for i in range(1, 100):
    deltatime = []

    voltage = []

    for i in range(1, 10):
        deltatime.append(float(oscilloscope.query('MEASURE:DELTATIME? CHANNEL3,CHANNEL4')))

        voltage.append(float(multimeter.query('MEASURE:VOLTAGE?')))

        time.sleep(0.1)

    DELTATIME.append(sum(deltatime) / len(deltatime))

    VOLTAGE.append(sum(voltage) / len(voltage))


