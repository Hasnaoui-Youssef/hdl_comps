library ieee;
use ieee.std_logic_1164.all;

entity pfd is
    port (
        clk_ref : in  std_logic;
        clk_fb  : in  std_logic;
        rst     : in  std_logic;
        up      : out std_logic;
        down    : out std_logic
    );
end entity;

architecture rtl of pfd is
    signal up_r, down_r : std_logic := '0';
begin
    up   <= up_r;
    down <= down_r;

    process(clk_ref, clk_fb, rst, up_r, down_r)
    begin
        if rst = '1' then
            up_r   <= '0';
            down_r <= '0';

        elsif rising_edge(clk_ref) then
            up_r <= '1';

        elsif rising_edge(clk_fb) then
            down_r <= '1';
        end if;

        if up_r = '1' and down_r = '1' then
            up_r   <= '0';
            down_r <= '0';
        end if;
    end process;
end architecture;

