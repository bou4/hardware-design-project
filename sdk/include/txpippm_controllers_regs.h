// -----------------------------------------------------------------------------
// 'txpippm_controllers' Register Definitions
// Revision: 45
// -----------------------------------------------------------------------------
// Generated on 2019-05-07 at 14:35 (UTC) by airhdl version 2019.02.1
// -----------------------------------------------------------------------------
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.
// -----------------------------------------------------------------------------

#ifndef TXPIPPM_CONTROLLERS_H
#define TXPIPPM_CONTROLLERS_H

/* Revision number of the 'txpippm_controllers' register map */
#define TXPIPPM_CONTROLLERS_REVISION 45

/* Default base address of the 'txpippm_controllers' register map */
#define TXPIPPM_CONTROLLERS_DEFAULT_BASEADDR 0x80000000

/* Register 'reset' */
#define RESET_OFFSET 0x00000000 /* address offset of the 'reset' register */

/* Field  'reset.reset' */
#define RESET_RESET_BIT_OFFSET 0 /* bit offset of the 'reset' field */
#define RESET_RESET_BIT_WIDTH 1 /* bit width of the 'reset' field */
#define RESET_RESET_BIT_MASK 0x00000001 /* bit mask of the 'reset' field */
#define RESET_RESET_RESET 0x0 /* reset value of the 'reset' field */

/* Register 'sel' */
#define SEL_OFFSET 0x00000004 /* address offset of the 'sel' register */

/* Field  'sel.sel' */
#define SEL_SEL_BIT_OFFSET 0 /* bit offset of the 'sel' field */
#define SEL_SEL_BIT_WIDTH 10 /* bit width of the 'sel' field */
#define SEL_SEL_BIT_MASK 0x000003FF /* bit mask of the 'sel' field */
#define SEL_SEL_RESET 0x0 /* reset value of the 'sel' field */

/* Register 'pulse' */
#define PULSE_OFFSET 0x00000008 /* address offset of the 'pulse' register */

/* Field  'pulse.pulse' */
#define PULSE_PULSE_BIT_OFFSET 0 /* bit offset of the 'pulse' field */
#define PULSE_PULSE_BIT_WIDTH 1 /* bit width of the 'pulse' field */
#define PULSE_PULSE_BIT_MASK 0x00000001 /* bit mask of the 'pulse' field */
#define PULSE_PULSE_RESET 0x0 /* reset value of the 'pulse' field */

/* Register 'stepsize' */
#define STEPSIZE_OFFSET 0x0000000C /* address offset of the 'stepsize' register */

/* Field  'stepsize.stepsize' */
#define STEPSIZE_STEPSIZE_BIT_OFFSET 0 /* bit offset of the 'stepsize' field */
#define STEPSIZE_STEPSIZE_BIT_WIDTH 5 /* bit width of the 'stepsize' field */
#define STEPSIZE_STEPSIZE_BIT_MASK 0x0000001F /* bit mask of the 'stepsize' field */
#define STEPSIZE_STEPSIZE_RESET 0x0 /* reset value of the 'stepsize' field */

/* Register 'bufstatus' */
#define BUFSTATUS_OFFSET 0x00000010 /* address offset of the 'bufstatus' register */

/* Field  'bufstatus.bufstatus' */
#define BUFSTATUS_BUFSTATUS_BIT_OFFSET 0 /* bit offset of the 'bufstatus' field */
#define BUFSTATUS_BUFSTATUS_BIT_WIDTH 20 /* bit width of the 'bufstatus' field */
#define BUFSTATUS_BUFSTATUS_BIT_MASK 0x000FFFFF /* bit mask of the 'bufstatus' field */
#define BUFSTATUS_BUFSTATUS_RESET 0x0 /* reset value of the 'bufstatus' field */

#endif  /* TXPIPPM_CONTROLLERS_H */
