library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
    generic(
        sys_clk : integer := 50_000_000;
        pwm_freq : integer := 100_000;
        bit_resolution : integer := 8
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        duty_cycle : in std_logic_vector(bit_resolution - 1 downto 0);
        pwm : out std_logic
    );
end entity pwm;

architecture rtl of pwm is
    constant period : integer := sys_clk / pwm_freq;
    signal count :  integer range 0 to period - 1 := 0;
begin
counter_proc: process(clk, rst)
    begin
        if rst = '1' then
           count <= 0;
           pwm <= '0';
        elsif rising_edge(clk) then
            if(count = period - 1) then
                count <= 0;
            else
                count <= count + 1;
            end if;
            if(count < to_integer(unsigned(duty_cycle))) then
                pwm <= '1';
            else
                pwm <= '0';
            end if;
        end if;
end process counter_proc;


end architecture rtl;
