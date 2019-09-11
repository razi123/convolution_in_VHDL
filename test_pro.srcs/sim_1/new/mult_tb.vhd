-- ************************************************* MULT_tb ********************************************************

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.08.2019 20:38:47
-- Design Name: 
-- Module Name: mult_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.multPkg.all;

entity mult_tb is
--  Port ( );
end mult_tb;

architecture Behavioral of mult_tb is

-- ---------------------------------------------------------------------------------------------------------------------
--                                          COMPONENTS DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------

component matMult
        
 Port ( clk : in STD_LOGIC;
           clkEnb : in STD_LOGIC;
           rst: in STD_LOGIC;
           inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
           outMat : out t_2d_out(0 to (matRow*matCol)-1);
           doneBit : out STD_LOGIC:='0');
end component;

-- ---------------------------------------------------------------------------------------------------------------------
--                                         SIGNAL DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------

signal s_clk : STD_LOGIC := '0';
signal s_done : STD_LOGIC;
signal s_rst : STD_LOGIC;
signal s_clkEnb : STD_LOGIC;
signal s_inpMat : t_2d_array(0 to matRow-1, 0 to matcol-1);
signal s_outMat : t_2d_out(0 to (matRow*matCol)-1);

constant  clkPeriod : time := 20ns;

-- ---------------------------------------------------------------------------------------------------------------------
--                                         ARCHITECTURE BEGINS 
-- ---------------------------------------------------------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------------------------------------------------------
--                                         COMPONENT INSTANTIATION 
-- ---------------------------------------------------------------------------------------------------------------------

uut : matMult 
      Port map (clk => s_clk,
                inpMat => s_inpMat,
                clkEnb => s_clkEnb, 
                rst=> s_rst, 
                outMat=>s_outMat, 
                doneBit => s_done); 


clockGenerator : process
begin
    s_clk <= not s_clk after clkPeriod /2 ;
    wait for clkPeriod/2;
end process;         -- clockGenerator process ends here


stumuli: process  
begin

-- ---------------------------------------------------------------------------------------------------------------------
--                                         TEST CASE for 4x4
-- ---------------------------------------------------------------------------------------------------------------------

if matRow =4 and matCol=4 then

    s_rst <= '1';
    s_clkEnb <= '0';

    wait for clkPeriod*2;

    s_rst <= '0';
    s_clkEnb <= '1';

    s_inpMat <= (("0001","0010","0011","0100"),("0001","0010","0011","0100"),("0001","0010","0011","0100"),
                    ("0001","0010","0011","0100"));     
                 
    wait until s_done='1'; 
    
    s_rst <= '1';
    s_clkEnb <= '0';

    wait for clkPeriod*2;

    s_rst <= '0';
    s_clkEnb <= '1';

    s_inpMat <= (("0001","0011","0011","0100"),("0001","0011","0011","0100"),("0001","0011","0011","0100"),
                 ("0001","0011","0011","0100"));    
                 
    wait until s_done='1';           
    
-- ---------------------------------------------------------------------------------------------------------------------
--                                         TEST CASE for 5x5
-- ---------------------------------------------------------------------------------------------------------------------

elsif matRow =5 and matCol=5 then

    s_rst <= '1';
    s_clkEnb <= '0';

    wait for clkPeriod*2;

    s_rst <= '0';
    s_clkEnb <= '1';

    s_inpMat <= (("0001","0010","0011","0100", "0101"),("0001","0010","0011","0100", "0101"),("0001","0010","0011","0100", "0101"),
                 ("0001","0010","0011","0100", "0101"), ("0001","0010","0011","0100", "0101"));     

    wait until s_done <='1';

    s_rst <= '1';
    s_clkEnb <= '0';

    wait for clkPeriod*2;

    s_rst <= '0';
    s_clkEnb <= '1';

    s_inpMat <= (("0001","0011","0011","0011", "0001"),("0001","0011","0011","0011", "0001"),("0001","0011","0011","0011", "0001"),
                 ("0001","0011","0011","0011", "0001"), ("0001","0011","0011","0011", "0001"));  
                 
    wait until s_done='1';  
    
    else
        report "Check the matrix row and column size in the multPkg file" severity warning;

    end if;
    
end process;             -- Stumuli process ends here

end Behavioral;