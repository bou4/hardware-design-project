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
    
    def system_header(self, value):
        self.resource.write('SYSTem:HEADer {}'.format(value))
    
    def measure_define_deltatime(self, start_edge_direction, start_edge_number, start_edge_position, stop_edge_direction, stop_edge_number, stop_edge_position):
        self.resource.write('MEASure:DEFine DELTatime, {}, {}, {}, {}, {}, {}'.format(
                start_edge_direction, start_edge_number, start_edge_position,
                stop_edge_direction, stop_edge_number, stop_edge_position))
    
    def measure_deltatime(self, source_1, source_2):
        return float(self.resource.query('MEASure:DELTatime? {}, {}'.format(source_1, source_2)))

    def timebase_precision(self, value):
        self.resource.write('TIMebase:PRECision {}'.format(value))

    def timebase_precision_radio_frequency(self, value):
        self.resource.write('TIMebase:PRECision:RFRequency {}'.format(value))

    def timebase_scale(self, value):
        self.resource.write('TIMebase:SCALe {}'.format(value))

    def channel_display(self, channel, value):
        self.resource.write('CHANnel{}:DISPlay {}'.format(channel, value))
    
    def channel_scale(self, channel, scale):
        self.resource.write('CHANnel{}:SCALe {}'.format(channel, scale))


class Multimeter(Instrument):
    def get_identification_string(self):
        return 'HEWLETT-PACKARD,34401A,0,11-5-2'

    def measure_voltage_dc(self):
        return float(self.resource.query('MEASure:VOLTage:DC?'))


class FPGA(Instrument):
    def get_identification_string(self):
        return 'IDLAB,AETHER,0.1,0.1'
    
    def transceivers_reset(self):
        self.resource.write('TRANSceivers:RESet')

    def transceivers_select(self, channel):
        self.resource.write('TRANSceivers:SELect {}'.format(channel))

    def transceivers_select_query(self):
        return self.resource.query('TRANSceivers:SELect?')
    
    def transceivers_phase(self, value):
        self.resource.write('TRANSceivers:PHASe {}'.format(value))
