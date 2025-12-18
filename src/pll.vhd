library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pll_top is
    port (
        clk_ref : in  std_logic;
        rst     : in  std_logic;
        clk_out : out std_logic
    );
end entity;

architecture rtl of pll_top is
    signal ref_div_clk : std_logic;
    signal fb_clk      : std_logic;
    signal up, down    : std_logic;
    signal ctrl        : signed(31 downto 0);
begin

    ref_div : entity work.clk_div
        generic map (DIV => 2)
        port map (
            clk_in  => clk_ref,
            rst     => rst,
            clk_out => ref_div_clk
        );

    pfd_i : entity work.pfd
        port map (
            clk_ref => ref_div_clk,
            clk_fb  => fb_clk,
            rst     => rst,
            up      => up,
            down    => down
        );

    lf : entity work.loop_filter
        port map (
            clk  => ref_div_clk,
            rst  => rst,
            up   => up,
            down => down,
            ctrl => ctrl
        );

    nco_i : entity work.nco
        port map (
            clk      => clk_ref,
            rst      => rst,
            freq_ctl => ctrl,
            clk_out  => fb_clk
        );

    clk_out <= fb_clk;

end architecture;

