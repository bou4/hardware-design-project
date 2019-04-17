#ifndef CONTROL_H
#define CONTROL_H

/* SCPI */
#include "scpi/scpi.h"

#define SCPI_INPUT_BUFFER_LENGTH 256

#define SCPI_ERROR_QUEUE_SIZE 20

/* Manufacturer */
#define SCPI_IDN1 "IDLAB"
/* Model */
#define SCPI_IDN2 "AETHER"
/* Hardware version */
#define SCPI_IDN3 "0.1"
/* Software version */
#define SCPI_IDN4 "0.1"

extern const scpi_command_t scpi_commands[];

extern scpi_interface_t scpi_interface;

extern char scpi_input_buffer[];

extern scpi_error_t scpi_error_queue_data[];

extern scpi_t scpi_context;

size_t SCPI_Write(scpi_t* context, const char* data, size_t length);

#endif /* CONTROL_H */
