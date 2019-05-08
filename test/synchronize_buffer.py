# Control measurement devices
import common

## FPGA
fpga = common.FPGA('ASRL5::INSTR')
fpga.transceivers_reset()

for i in range(0, 9):
    fpga.transceivers_select('OUTPUT{}'.format(i))
    fpga.transceivers_synchronize()
