# Scientific computing
import numpy

# Time access and conversions
import time
import datetime

# Control measurement devices
import common

## Oscilloscope
oscilloscope = common.Oscilloscope('GPIB1::8::INSTR')
oscilloscope.system_header('OFF')
oscilloscope.timebase_precision_radio_frequency('2E9')
oscilloscope.timebase_precision('ON')
oscilloscope.timebase_scale('100E-12')
oscilloscope.channel_display(3, 'ON')
oscilloscope.channel_scale(3, 50E-3)
oscilloscope.channel_display(4, 'ON')
oscilloscope.channel_scale(4, 50E-3)
oscilloscope.measure_define_deltatime('RISING', 1, 'MIDDLE', 'RISING', 1, 'MIDDLE')

## Multimeter
multimeter = common.Multimeter('GPIB1::27::INSTR')

## FPGA
fpga = common.FPGA('ASRL5::INSTR')
fpga.transceivers_reset()
fpga.transceivers_select('OUTPUT5')

# Begin measurement
voltages = []
deltatimes = []

for i in range(1, 1001):
    voltages.append(multimeter.measure_voltage_dc())
    deltatimes.append(oscilloscope.measure_deltatime('CHANNEL3', 'CHANNEL4'))
    fpga.transceivers_phase(1)
    time.sleep(0.1)
    print(i)

numpy.savetxt(datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S.txt'), numpy.column_stack((deltatimes, voltages)))
