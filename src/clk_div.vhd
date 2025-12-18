library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
    generic (
        DIV : integer := 2
    );
    port (
        clk_in  : in  std_logic;
        rst     : in  std_logic;
        clk_out : out std_logic
    );
end entity;

architecture rtl of clk_div is
    signal cnt : integer range 0 to DIV-1 := 0;
    signal clk_r : std_logic := '0';
begin
    clk_out <= clk_r;

    process(clk_in, rst)
    begin
        if rst = '1' then
            cnt   <= 0;
            clk_r <= '0';
        elsif rising_edge(clk_in) then
            if cnt = DIV-1 then
                cnt   <= 0;
                clk_r <= not clk_r;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
end architecture;

