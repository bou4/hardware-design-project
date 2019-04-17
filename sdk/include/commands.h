#ifndef COMMANDS_H
#define COMMANDS_H

/* SCPI */
#include "scpi/scpi.h"

scpi_result_t Transceivers_Initialize();

scpi_result_t Transceivers_Reset(scpi_t* context);

scpi_result_t Transceivers_Select(scpi_t* context);
scpi_result_t Transceivers_SelectQ(scpi_t* context);

scpi_result_t Transceivers_Phase(scpi_t * context);

#endif /* COMMANDS_H */
