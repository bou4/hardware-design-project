/* Standard library */
#include <stdio.h>

/* Application */
#include "commands.h"
#include "control.h"

/* http://www.ivifoundation.org/docs/scpi-99.pdf
 * https://ieeexplore.ieee.org/document/1352831
 */
const scpi_command_t scpi_commands[] =
{
	/* IEEE Mandated Commands (SCPI std V1999.0 4.1.1) */
	/* Clear Status Command */
	{ .pattern = "*CLS"                          , .callback = SCPI_CoreCls                  , },
	/* Standard Event Status Enable Command */
	{ .pattern = "*ESE"                          , .callback = SCPI_CoreEse                  , },
	/* Standard Event Status Enable Query */
	{ .pattern = "*ESE?"                         , .callback = SCPI_CoreEseQ                 , },
	/* Standard Event Status Register Query */
	{ .pattern = "*ESR?"                         , .callback = SCPI_CoreEsrQ                 , },
	/* Identification Query */
	{ .pattern = "*IDN?"                         , .callback = SCPI_CoreIdnQ                 , },
	/* Operation Complete Command */
	{ .pattern = "*OPC"                          , .callback = SCPI_CoreOpc                  , },
	/* Operation Complete Query */
	{ .pattern = "*OPC?"                         , .callback = SCPI_CoreOpcQ                 , },
	/* Reset Command */
	{ .pattern = "*RST"                          , .callback = SCPI_CoreRst                  , },
	/* Service Request Enable Command */
	{ .pattern = "*SRE"                          , .callback = SCPI_CoreSre                  , },
	/* Service Request Enable Query */
	{ .pattern = "*SRE?"                         , .callback = SCPI_CoreSreQ                 , },
	/* Read Status Byte Query */
	{ .pattern = "*STB?"                         , .callback = SCPI_CoreStbQ                 , },
	/* Self-Test Query */
	{ .pattern = "*TST?"                         , .callback = SCPI_CoreTstQ                 , },
	/* Wait-to-Continue Command */
	{ .pattern = "*WAI"                          , .callback = SCPI_CoreWai                  , },

	/* Required SCPI commands (SCPI std V1999.0 4.2.1) */
	{ .pattern = "SYSTem:ERRor[:NEXT]?"          , .callback = SCPI_SystemErrorNextQ         , },
	{ .pattern = "SYSTem:VERSion?"               , .callback = SCPI_SystemVersionQ           , },

	/* Not implemented */
	{ .pattern = "STATus:OPERation?"             , .callback = SCPI_StubQ                    , },
	{ .pattern = "STATus:OPERation[:EVENt]?"     , .callback = SCPI_StubQ                    , },
	{ .pattern = "STATus:OPERation:CONDition?"   , .callback = SCPI_StubQ                    , },
	{ .pattern = "STATus:OPERation:ENABle"       , .callback = SCPI_Stub                     , },
	{ .pattern = "STATus:OPERation:ENABle?"      , .callback = SCPI_StubQ                    , },

	{ .pattern = "STATus:QUEStionable[:EVENt]?"  , .callback = SCPI_StatusQuestionableEventQ , },

	/* Not implemented */
	{ .pattern = "STATus:QUEStionable:CONDition?", .callback = SCPI_StubQ                    , },

	{ .pattern = "STATus:QUEStionable:ENABle"    , .callback = SCPI_StatusQuestionableEnable , },
	{ .pattern = "STATus:QUEStionable:ENABle?"   , .callback = SCPI_StatusQuestionableEnableQ, },

	{ .pattern = "STATus:PRESet"                 , .callback = SCPI_StatusPreset             , },

	/* Application */
	{ .pattern = "TRANSceivers:RESet"            , .callback = Transceivers_Reset            , },
	{ .pattern = "TRANSceivers:SELect"           , .callback = Transceivers_Select           , },
	{ .pattern = "TRANSceivers:SELect?"          , .callback = Transceivers_SelectQ          , },
	{ .pattern = "TRANSceivers:PHASe"            , .callback = Transceivers_Phase            , },
	{ .pattern = "TRANSceivers:STATus?"          , .callback = Transceivers_StatusQ          , },
	{ .pattern = "TRANSceivers:SYNChronize"      , .callback = Transceivers_Synchronize      , },

	SCPI_CMD_LIST_END
};

scpi_interface_t scpi_interface =
{
	.error   = NULL,
	.write   = SCPI_Write,
	.control = NULL,
	.flush   = NULL,
	.reset   = NULL
};

char scpi_input_buffer[SCPI_INPUT_BUFFER_LENGTH];

scpi_error_t scpi_error_queue_data[SCPI_ERROR_QUEUE_SIZE];

scpi_t scpi_context;

size_t SCPI_Write(scpi_t* context, const char* data, size_t length)
{
    return fwrite(data, 1, length, stdout);
}
