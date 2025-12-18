library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco is
    generic (
        FREQ_BIAS : unsigned(31 downto 0) := x"10000000"
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        freq_ctl : in  signed(31 downto 0);
        clk_out  : out std_logic
    );
end entity;

architecture rtl of nco is
    signal phase : unsigned(31 downto 0) := (others => '0');
begin
    clk_out <= phase(31);

    process(clk, rst)
    begin
        if rst = '1' then
            phase <= (others => '0');
        elsif rising_edge(clk) then
            phase <= phase + FREQ_BIAS + unsigned(freq_ctl);
        end if;
    end process;
end architecture;

