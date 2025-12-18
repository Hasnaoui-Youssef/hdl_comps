library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity loop_filter is
    generic (
        KP : integer := 1;
        KI : integer := 1
    );
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        up    : in  std_logic;
        down  : in  std_logic;
        ctrl  : out signed(31 downto 0)
    );
end entity;

architecture rtl of loop_filter is
    signal acc : signed(31 downto 0) := (others => '0');
begin
    ctrl <= acc;

    process(clk, rst)
    begin
        if rst = '1' then
            acc <= (others => '0');
        elsif rising_edge(clk) then
            if up = '1' and down = '0' then
                acc <= acc + to_signed(KP + KI, 32);
            elsif down = '1' and up = '0' then
                acc <= acc - to_signed(KP + KI, 32);
            end if;
        end if;
    end process;
end architecture;

