library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rgb2g_tb is
end entity rgb2g_tb;

architecture rtl of rgb2g_tb is
    constant CLK_P : time := 10 ns;
    signal clk_stop : boolean;
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal enable : std_logic := '0';
    signal valid : std_logic := '0';
    signal rgb : std_logic_vector(23 downto 0) := (others => '0');
    signal gray : std_logic_vector(7 downto 0) := (others => '0');

    type test_case_t is record
        r, g, b : integer range 0 to 255;
    end record;

    type test_case_arr is array (natural range <>) of test_case_t;

    constant TEST_CASES :  test_case_arr := (
        (0, 0, 0),
        (255, 255, 255),
        (255, 0, 0),
        (0, 255, 0),
        (0, 0, 255),
        (10, 10, 10),
        (50, 30, 60)
    );
begin

    uut: entity work.rgb2g
     port map(
        clk => clk,
        rst => rst,
        enable => enable,
        valid => valid,
        rgb => rgb,
        gray => gray
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
        for i in TEST_CASES'range loop
            rst <= '1';
            wait until rising_edge(clk);
            rst <= '0';
            rgb <=   std_logic_vector(to_unsigned(TEST_CASES(i).r, 8)) &
                     std_logic_vector(to_unsigned(TEST_CASES(i).g, 8)) &
                     std_logic_vector(to_unsigned(TEST_CASES(i).b, 8));
            enable <= '1';
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            wait until rising_edge(clk);
            enable <= '0';
            wait until rising_edge(clk);
        end loop;
        wait for 10 ns;
        clk_stop <= true;

    end process stim;



end architecture rtl;
