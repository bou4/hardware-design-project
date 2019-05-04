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
oscilloscope.channel_scale(3, 100E-3)
oscilloscope.channel_display(4, 'ON')
oscilloscope.channel_scale(4, 100E-3)
oscilloscope.measure_define_deltatime('RISING', 1, 'MIDDLE', 'RISING', 1, 'MIDDLE')

## FPGA
fpga = common.FPGA('ASRL5::INSTR')
fpga.transceivers_reset()
fpga.transceivers_select('OUTPUT5')

# This is large in terms of us...
deltatime = 1

while abs(deltatime) > 1e-12:
    if deltatime > 0:
        # Decrement phase
        fpga.transceivers_phase(-1)
    else:
        # Increment phase
        fpga.transceivers_phase(1)

    deltatime = oscilloscope.measure_deltatime('CHANNEL3', 'CHANNEL4')

    time.sleep(0.05)
