library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end entity pwm_tb;

architecture rtl of pwm_tb is
    constant CLK_P : time := 1 ns;
    constant sys_freq : integer := 1_000_000_000;
    constant pwm_freq : integer := 1_000_000;
    constant bit_resolution : integer := 10;
    signal clk_stop : boolean;
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal duty_cycle : std_logic_vector(bit_resolution - 1 downto 0);
    signal pwm : std_logic;

begin

    uut: entity work.pwm
    generic map(
        sys_clk => sys_freq,
        pwm_freq => pwm_freq,
        bit_resolution => bit_resolution
    )
    port map(
        clk => clk,
        rst => rst,
        duty_cycle => duty_cycle,
        pwm => pwm
    );

    clk_process: process
    begin
        while not clk_stop loop
            clk <= '0', '1' after CLK_P / 2;
            wait for CLK_P;
        end loop;
        wait;
    end process clk_process;

    stim: process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        duty_cycle <= "1100000000";
        rst <= '0';
        wait until rising_edge(clk);
        wait for 50 us;
        clk_stop <= true;

    end process stim;



end architecture rtl;
