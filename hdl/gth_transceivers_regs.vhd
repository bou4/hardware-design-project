-- -----------------------------------------------------------------------------
-- 'gth_transceivers' Register Component
-- Revision: 33
-- -----------------------------------------------------------------------------
-- Generated on 2019-04-19 at 14:39 (UTC) by airhdl version 2019.02.1
-- -----------------------------------------------------------------------------
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
-- POSSIBILITY OF SUCH DAMAGE.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gth_transceivers_regs_pkg.all;

entity gth_transceivers_regs is
    generic(
        AXI_ADDR_WIDTH : integer := 32;  -- width of the AXI address bus
        BASEADDR : std_logic_vector(31 downto 0) := x"80000000" -- the register file's system base address		
    );
    port(
        -- Clock and Reset
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;
        -- AXI Write Address Channel
        s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        -- AXI Write Data Channel
        s_axi_wdata   : in  std_logic_vector(31 downto 0);
        s_axi_wstrb   : in  std_logic_vector(3 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        -- AXI Read Address Channel
        s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        -- AXI Read Data Channel
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        -- AXI Write Response Channel
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        -- User Ports
        reset_strobe : out std_logic; -- Strobe signal for register 'reset' (pulsed when the register is written from the bus)
        reset_reset : out std_logic_vector(0 downto 0); -- Value of register 'reset', field 'reset'
        sel_strobe : out std_logic; -- Strobe signal for register 'sel' (pulsed when the register is written from the bus)
        sel_sel : out std_logic_vector(9 downto 0); -- Value of register 'sel', field 'sel'
        pulse_strobe : out std_logic; -- Strobe signal for register 'pulse' (pulsed when the register is written from the bus)
        pulse_pulse : out std_logic_vector(0 downto 0); -- Value of register 'pulse', field 'pulse'
        stepsize_strobe : out std_logic; -- Strobe signal for register 'stepsize' (pulsed when the register is written from the bus)
        stepsize_stepsize : out std_logic_vector(4 downto 0) -- Value of register 'stepsize', field 'stepsize'
    );
end entity gth_transceivers_regs;

architecture RTL of gth_transceivers_regs is

    -- Constants
    constant AXI_OKAY           : std_logic_vector(1 downto 0) := "00";
    constant AXI_DECERR         : std_logic_vector(1 downto 0) := "11";

    -- Registered signals
    signal s_axi_awready_r    : std_logic;
    signal s_axi_wready_r     : std_logic;
    signal s_axi_awaddr_reg_r : unsigned(s_axi_awaddr'range);
    signal s_axi_bvalid_r     : std_logic;
    signal s_axi_bresp_r      : std_logic_vector(s_axi_bresp'range);
    signal s_axi_arready_r    : std_logic;
    signal s_axi_araddr_reg_r : unsigned(s_axi_araddr'range);
    signal s_axi_rvalid_r     : std_logic;
    signal s_axi_rresp_r      : std_logic_vector(s_axi_rresp'range);
    signal s_axi_wdata_reg_r  : std_logic_vector(s_axi_wdata'range);
    signal s_axi_wstrb_reg_r  : std_logic_vector(s_axi_wstrb'range);
    signal s_axi_rdata_r      : std_logic_vector(s_axi_rdata'range);
    
    -- User-defined registers
    signal s_reset_strobe_r : std_logic;
    signal s_reg_reset_reset_r : std_logic_vector(0 downto 0);
    signal s_sel_strobe_r : std_logic;
    signal s_reg_sel_sel_r : std_logic_vector(9 downto 0);
    signal s_pulse_strobe_r : std_logic;
    signal s_reg_pulse_pulse_r : std_logic_vector(0 downto 0);
    signal s_stepsize_strobe_r : std_logic;
    signal s_reg_stepsize_stepsize_r : std_logic_vector(4 downto 0);

begin

    ----------------------------------------------------------------------------
    -- Inputs
    --

    ----------------------------------------------------------------------------
    -- Read-transaction FSM
    --    
    read_fsm : process(axi_aclk, axi_aresetn) is
        constant MEM_WAIT_COUNT : natural := 2;
        type t_state is (IDLE, READ_REGISTER, WAIT_MEMORY_RDATA, READ_RESPONSE, DONE);
        -- registered state variables
        variable v_state_r          : t_state;
        variable v_rdata_r          : std_logic_vector(31 downto 0);
        variable v_rresp_r          : std_logic_vector(s_axi_rresp'range);
        variable v_mem_wait_count_r : natural range 0 to MEM_WAIT_COUNT - 1;
        -- combinatorial helper variables
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            v_rdata_r          := (others => '0');
            v_rresp_r          := (others => '0');
            v_mem_wait_count_r := 0;
            s_axi_arready_r    <= '0';
            s_axi_rvalid_r     <= '0';
            s_axi_rresp_r      <= (others => '0');
            s_axi_araddr_reg_r <= (others => '0');
            s_axi_rdata_r      <= (others => '0');
 
        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_arready_r <= '0';

            case v_state_r is

                -- Wait for the start of a read transaction, which is 
                -- initiated by the assertion of ARVALID
                when IDLE =>
                    v_mem_wait_count_r := 0;
                    --
                    if s_axi_arvalid = '1' then
                        s_axi_araddr_reg_r <= unsigned(s_axi_araddr); -- save the read address
                        s_axi_arready_r    <= '1'; -- acknowledge the read-address
                        v_state_r          := READ_REGISTER;
                    end if;

                -- Read from the actual storage element
                when READ_REGISTER =>
                    -- defaults:
                    v_addr_hit := false;
                    v_rdata_r  := (others => '0');
                    
                    -- register 'reset' at address offset 0x0 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + RESET_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_reset_reset_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'sel' at address offset 0x4 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + SEL_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(9 downto 0) := s_reg_sel_sel_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'pulse' at address offset 0x8 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_pulse_pulse_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'stepsize' at address offset 0xC 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + STEPSIZE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(4 downto 0) := s_reg_stepsize_stepsize_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    --
                    if v_addr_hit then
                        v_rresp_r := AXI_OKAY;
                    else
                        v_rresp_r := AXI_DECERR;
                        -- pragma translate_off
                        report "ARADDR decode error" severity warning;
                        -- pragma translate_on
                        v_state_r := READ_RESPONSE;
                    end if;

                -- Wait for memory read data
                when WAIT_MEMORY_RDATA =>
                    if v_mem_wait_count_r = MEM_WAIT_COUNT-1 then
                        v_state_r      := READ_RESPONSE;
                    else
                        v_mem_wait_count_r := v_mem_wait_count_r + 1;
                    end if;

                -- Generate read response
                when READ_RESPONSE =>
                    s_axi_rvalid_r <= '1';
                    s_axi_rresp_r  <= v_rresp_r;
                    s_axi_rdata_r  <= v_rdata_r;
                    --
                    v_state_r      := DONE;

                -- Write transaction completed, wait for master RREADY to proceed
                when DONE =>
                    if s_axi_rready = '1' then
                        s_axi_rvalid_r <= '0';
                        s_axi_rdata_r   <= (others => '0');
                        v_state_r      := IDLE;
                    end if;
            end case;
        end if;
    end process read_fsm;

    ----------------------------------------------------------------------------
    -- Write-transaction FSM
    --    
    write_fsm : process(axi_aclk, axi_aresetn) is
        type t_state is (IDLE, ADDR_FIRST, DATA_FIRST, UPDATE_REGISTER, DONE);
        variable v_state_r  : t_state;
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            s_axi_awready_r    <= '0';
            s_axi_wready_r     <= '0';
            s_axi_awaddr_reg_r <= (others => '0');
            s_axi_wdata_reg_r  <= (others => '0');
            s_axi_wstrb_reg_r  <= (others => '0');
            s_axi_bvalid_r     <= '0';
            s_axi_bresp_r      <= (others => '0');
            --            
            s_reset_strobe_r <= '0';
            s_reg_reset_reset_r <= std_logic_vector'("0");
            s_sel_strobe_r <= '0';
            s_reg_sel_sel_r <= std_logic_vector'("0000000000");
            s_pulse_strobe_r <= '0';
            s_reg_pulse_pulse_r <= std_logic_vector'("0");
            s_stepsize_strobe_r <= '0';
            s_reg_stepsize_stepsize_r <= std_logic_vector'("00000");

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_awready_r <= '0';
            s_axi_wready_r  <= '0';
            s_reset_strobe_r <= '0';
            s_sel_strobe_r <= '0';
            s_pulse_strobe_r <= '0';
            s_stepsize_strobe_r <= '0';

            -- Self-clearing fields:
            s_reg_reset_reset_r <= (others => '0');
            s_reg_pulse_pulse_r <= (others => '0');

            case v_state_r is

                -- Wait for the start of a write transaction, which may be 
                -- initiated by either of the following conditions:
                --   * assertion of both AWVALID and WVALID
                --   * assertion of AWVALID
                --   * assertion of WVALID
                when IDLE =>
                    if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        s_axi_wdata_reg_r  <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r  <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r     <= '1'; -- acknowledge the write-data
                        v_state_r          := UPDATE_REGISTER;
                    elsif s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := ADDR_FIRST;
                    elsif s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := DATA_FIRST;
                    end if;

                -- Address-first write transaction: wait for the write-data
                when ADDR_FIRST =>
                    if s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := UPDATE_REGISTER;
                    end if;

                -- Data-first write transaction: wait for the write-address
                when DATA_FIRST =>
                    if s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := UPDATE_REGISTER;
                    end if;

                -- Update the actual storage element
                when UPDATE_REGISTER =>
                    s_axi_bresp_r               <= AXI_OKAY; -- default value, may be overriden in case of decode error
                    s_axi_bvalid_r              <= '1';
                    --
                    v_addr_hit := false;
                    -- register 'reset' at address offset 0x0
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + RESET_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_reset_strobe_r <= '1';
                        -- field 'reset':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_reset_reset_r(0) <= s_axi_wdata_reg_r(0); -- reset(0)
                        end if;
                    end if;
                    -- register 'sel' at address offset 0x4
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + SEL_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_sel_strobe_r <= '1';
                        -- field 'sel':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(0) <= s_axi_wdata_reg_r(0); -- sel(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(1) <= s_axi_wdata_reg_r(1); -- sel(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(2) <= s_axi_wdata_reg_r(2); -- sel(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(3) <= s_axi_wdata_reg_r(3); -- sel(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(4) <= s_axi_wdata_reg_r(4); -- sel(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(5) <= s_axi_wdata_reg_r(5); -- sel(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(6) <= s_axi_wdata_reg_r(6); -- sel(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_sel_sel_r(7) <= s_axi_wdata_reg_r(7); -- sel(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_sel_sel_r(8) <= s_axi_wdata_reg_r(8); -- sel(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_sel_sel_r(9) <= s_axi_wdata_reg_r(9); -- sel(9)
                        end if;
                    end if;
                    -- register 'pulse' at address offset 0x8
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_strobe_r <= '1';
                        -- field 'pulse':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pulse_r(0) <= s_axi_wdata_reg_r(0); -- pulse(0)
                        end if;
                    end if;
                    -- register 'stepsize' at address offset 0xC
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + STEPSIZE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_stepsize_strobe_r <= '1';
                        -- field 'stepsize':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_stepsize_stepsize_r(0) <= s_axi_wdata_reg_r(0); -- stepsize(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_stepsize_stepsize_r(1) <= s_axi_wdata_reg_r(1); -- stepsize(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_stepsize_stepsize_r(2) <= s_axi_wdata_reg_r(2); -- stepsize(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_stepsize_stepsize_r(3) <= s_axi_wdata_reg_r(3); -- stepsize(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_stepsize_stepsize_r(4) <= s_axi_wdata_reg_r(4); -- stepsize(4)
                        end if;
                    end if;
                    --
                    if not v_addr_hit then
                        s_axi_bresp_r <= AXI_DECERR;
                        -- pragma translate_off
                        report "AWADDR decode error" severity warning;
                        -- pragma translate_on
                    end if;
                    --
                    v_state_r := DONE;

                -- Write transaction completed, wait for master BREADY to proceed
                when DONE =>
                    if s_axi_bready = '1' then
                        s_axi_bvalid_r <= '0';
                        v_state_r      := IDLE;
                    end if;

            end case;


        end if;
    end process write_fsm;

    ----------------------------------------------------------------------------
    -- Outputs
    --
    s_axi_awready <= s_axi_awready_r;
    s_axi_wready  <= s_axi_wready_r;
    s_axi_bvalid  <= s_axi_bvalid_r;
    s_axi_bresp   <= s_axi_bresp_r;
    s_axi_arready <= s_axi_arready_r;
    s_axi_rvalid  <= s_axi_rvalid_r;
    s_axi_rresp   <= s_axi_rresp_r;
    s_axi_rdata   <= s_axi_rdata_r;

    reset_strobe <= s_reset_strobe_r;
    reset_reset <= s_reg_reset_reset_r;
    sel_strobe <= s_sel_strobe_r;
    sel_sel <= s_reg_sel_sel_r;
    pulse_strobe <= s_pulse_strobe_r;
    pulse_pulse <= s_reg_pulse_pulse_r;
    stepsize_strobe <= s_stepsize_strobe_r;
    stepsize_stepsize <= s_reg_stepsize_stepsize_r;

end architecture RTL;
