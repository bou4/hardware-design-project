/* Xilinx */
#include "xil_io.h"

/* Application */
#include "commands.h"

/* AXI */
#include "gth_transceivers_regs.h"

scpi_result_t Transceivers_Reset(scpi_t* context)
{
	Xil_Out32(GTH_TRANSCEIVERS_DEFAULT_BASEADDR + RESET_OFFSET, 0x1);

    return SCPI_RES_OK;
}

int32_t current_channel;

scpi_choice_def_t channels[] = {
    {"OUTPut0", 0},
    {"OUTPut1", 1},
	{"OUTPut2", 2},
	{"OUTPut3", 3},
	{"OUTPut4", 4},
	{"OUTPut5", 5},
	{"OUTPut6", 6},
	{"OUTPut7", 7},
	{"OUTPut8", 8},
	{"OUTPut9", 9},
    SCPI_CHOICE_LIST_END
};

scpi_result_t Transceivers_Select(scpi_t* context)
{
    if (!SCPI_ParamChoice(context, channels, &current_channel, TRUE))
    {
        return SCPI_RES_ERR;
    }

    return SCPI_RES_OK;
}

scpi_result_t Transceivers_SelectQ(scpi_t* context)
{
	const char* name;

	SCPI_ChoiceToName(channels, current_channel, &name);

	SCPI_ResultCharacters(context, name, strlen(name));

    return SCPI_RES_OK;
}

scpi_result_t Transceivers_Phase(scpi_t * context)
{
	int32_t select = 1 << current_channel;

	int32_t stepsize;

	if (!SCPI_ParamInt32(context, &stepsize, TRUE))
	{
		return SCPI_RES_ERR;
	}

	if (stepsize > 0)
	{
		// Select 4 bits
		stepsize &= 0xF;
	}
	else
	{
		// Negate
		stepsize *= -1;

		// Select 4 bits
		stepsize &= 0xF;

		// Set sign bit
		stepsize |= (1 << 4);
	}

	Xil_Out32(GTH_TRANSCEIVERS_DEFAULT_BASEADDR + SEL_OFFSET, select);
	Xil_Out32(GTH_TRANSCEIVERS_DEFAULT_BASEADDR + STEPSIZE_OFFSET, stepsize);
	Xil_Out32(GTH_TRANSCEIVERS_DEFAULT_BASEADDR + PULSE_OFFSET, 0x1);

    return SCPI_RES_OK;
}
