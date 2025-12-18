library ieee;
use ieee.std_logic_1164.all;

entity pll_tb is
end entity;

architecture sim of pll_tb is
    signal clk_ref : std_logic := '0';
    signal rst     : std_logic := '1';
    signal clk_out : std_logic;
begin

    -- DUT
    dut : entity work.pll_top
        port map (
            clk_ref => clk_ref,
            rst     => rst,
            clk_out => clk_out
        );

    -- Reference clock: 50 MHz
    clk_ref <= not clk_ref after 10 ns;

    -- Reset sequence
    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

end architecture;

