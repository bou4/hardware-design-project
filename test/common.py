# Control measurement devices
import visa

resource_manager = visa.ResourceManager()

class IdentificationError(Exception):
    pass


class Instrument():
    def __init__(self, resource_name):
        self.resource = resource_manager.open_resource(resource_name)

        if self.get_identification_string() != self.identify():
            raise IdentificationError

        self.reset()
        self.clear_status()

    def get_identification_string(self):
        return ''

    def identify(self):
        return self.resource.query('*IDN?').rstrip()

    def reset(self):
        return self.resource.write('*RST')

    def clear_status(self):
        return self.resource.write('*CLS')

class Oscilloscope(Instrument):
    def get_identification_string(self):
        return 'Agilent Technologies,86100C,MY43490120,A.09.01'


class Multimeter(Instrument):
    def get_identification_string(self):
        return 'HEWLETT-PACKARD,34401A,0,11-5-2'


class FPGA(Instrument):
    def get_identification_string(self):
        return 'IDLAB,AETHER,0.1,0.1'
    
    def transceivers_reset(self):
        self.resource.write('TRANSceivers:RESet')

    def transceivers_select(self, channel):
        self.resource.write('TRANSceivers:SELect ' + str(channel))

    def transceivers_select_query(self):
        return self.resource.query('TRANSceivers:SELect?')
