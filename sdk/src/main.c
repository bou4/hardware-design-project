/* Standard library */
#include <stdio.h>

/* Xilinx */
#include "xil_printf.h"

/* SCPI */
#include "scpi/scpi.h"

/* Application */
#include "commands.h"
#include "control.h"
#include "main.h"
#include "platform.h"

int main()
{
    init_platform();

    SCPI_Init(&scpi_context,
        scpi_commands,
        &scpi_interface,
        scpi_units_def,
        SCPI_IDN1, SCPI_IDN2, SCPI_IDN3, SCPI_IDN4,
        scpi_input_buffer, SCPI_INPUT_BUFFER_LENGTH,
        scpi_error_queue_data, SCPI_ERROR_QUEUE_SIZE);

    char input_buffer[MAIN_INPUT_BUFFER_LENGTH];

    while (1)
    {
    	int index = 0;

    	while (index != MAIN_INPUT_BUFFER_LENGTH - 1)
    	{
    		input_buffer[index] = fgetc(stdin);

    		/* Parse command on EOL */
    		if (input_buffer[index++] == '\n')
    			break;
    	}

    	input_buffer[index] = '\0';

    	SCPI_Input(&scpi_context, input_buffer, strlen(input_buffer));
    }

    cleanup_platform();

    return 0;
}
