# Control measurement devices
import common

## FPGA
fpga = common.FPGA('ASRL5::INSTR')
fpga.transceivers_reset()

fpga.transceivers_select('OUTPUT5')
fpga.transceivers_synchronize()

fpga.transceivers_select('OUTPUT6')
fpga.transceivers_synchronize()
