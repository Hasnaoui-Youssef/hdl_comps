library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb2g is
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        valid : out std_logic;
        rgb : in std_logic_vector(23 downto 0);
        gray : out std_logic_vector(7 downto 0)
    );
end entity rgb2g;

architecture rtl of rgb2g is
   signal r, g, b : std_logic_vector(7 downto 0);
   signal r_sum, g_sum, b_sum, sum : std_logic_vector(15 downto 0);
   signal r_sl6, r_sl3, r_sl2, r_sl0: std_logic_vector(15 downto 0);
   signal g_sl7, g_sl4, g_sl2, g_sl1, g_sl0 : std_logic_vector(15 downto 0);
   signal b_sl4, b_sl3, b_sl2 : std_logic_vector(15 downto 0);

   signal enable_int : std_logic;
begin
    r <= rgb(23 downto 16);
    g <= rgb(15 downto 8);
    b <= rgb(7 downto 0);
    -- Approximately gray = 0.299r + 0.587g + 0.114b
    -- We can approximate to 0.3r + 0.59g + 0.11b
    -- Multiply by 256 we get ( 76.8r + 151.04g + 28.16b ) / 256
    -- Since we need the value to be between 0 and 255 we can further approximate the coefficients to
    -- R : 77 => 64 + 8 + 4 + 1
    -- G : 151 => 128 + 16 + 4 + 2 + 1
    -- B : 28 => 16 + 8 + 4
    -- Our final formula would look like:
    -- (r sl 6) + (r sl 3) + (r sl 2) + r
    -- + (g sl 7) + (g sl 4) + (g sl 2) + (g sl 1) + g
    -- + (b sl 4) + (b sl 3) + (b sl 2)
    -- We shift back everything 8 bits.
    r_sl6 <= "00" & r & "000000";
    r_sl3 <= "00000" & r & "000";
    r_sl2 <= "000000" & r & "00";
    r_sl0 <= "00000000" & r;

    g_sl7 <= "0" & g & "0000000";
    g_sl4 <= "0000" & g & "0000";
    g_sl2 <= "000000" & g & "00";
    g_sl1 <= "0000000" & g & "0";
    g_sl0 <= "00000000" & g;

    b_sl4 <= "0000" & b & "0000";
    b_sl3 <= "00000" & b & "000";
    b_sl2 <= "000000" & b & "00";

    r_sum <= std_logic_vector(unsigned(r_sl6) + unsigned(r_sl3) + unsigned(r_sl2) + unsigned(r_sl0));

    g_sum <= std_logic_vector(unsigned(g_sl7) + unsigned(g_sl4) + unsigned(g_sl2) + unsigned(g_sl1) + unsigned(g_sl0));

    b_sum <= std_logic_vector(unsigned(b_sl4) + unsigned(b_sl3) + unsigned(b_sl2));

    process(rst, clk)
    begin
        if rst = '1' then
            valid <= '0';
            sum <= (others => '0');
            gray <= (others => '0');
        elsif rising_edge(clk) then
            enable_int <= enable;
            valid <= enable_int;

            sum <= std_logic_vector(unsigned(r_sum) + unsigned(g_sum) + unsigned(b_sum));
            gray <= sum(15 downto 8);
        end if;
    end process;

end architecture rtl;
