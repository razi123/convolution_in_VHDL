
-- *************************************************Multiply COUNT ********************************************************

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2019 12:09:46
-- Design Name: 
-- Module Name: Multiply - Behavioral
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

entity Multiply is
    port(clk: in STD_LOGIC;
         clkEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         readEnb: in STD_LOGIC := '0';
         readData : in t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
         doneMult : out STD_LOGIC := '0';
         writeData : out t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1);
         outDataMultiply : out t_2d_out(0 to (matRow*matCol)-1));
end Multiply;

architecture Behavioral of Multiply is


-- ---------------------------------------------------------------------------------------------------------------------
--                                         SIGNAL DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------


signal s_temp: t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1) ; 
signal s_filtKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1) := (("0001","0000","0000"),("0000","0001","0000"),("0000","0000","0001"));
signal s_doneMultiply : STD_LOGIC :='0';
signal s_z : integer ;
signal s_tempOut : t_2d_out(0 to (matRow*matCol)-1);
signal s_readEnb_d :std_logic;
signal s_doneMult : STD_LOGIC := '0';

constant  clkPeriod : time := 20ns;

-- ---------------------------------------------------------------------------------------------------------------------
--                                         ARCHITECTURE BEGINS 
-- ---------------------------------------------------------------------------------------------------------------------

begin

convolve: process(clk,rst) is

begin
if rising_edge(clk) then 
    if rst='1' then 
       s_doneMultiply <= '0';
       s_readEnb_d<='0';
    else
        s_doneMultiply <= '0';
        if(readEnb = '1') then
            for i in 0 to 2 loop 
                for j in 0 to 2 loop
               
                s_temp(i,j) <=  readData(i,j) * s_filtKernal(i,j);
              
                end loop;
            end loop;
                    
        end if;
    s_readEnb_d<=readEnb;
    end if;
    
end if;
end process;  ---- convolve Process ends here



convolveAdd : process(clk,rst) is
begin
if rising_edge(clk) then     
 if rst='1' then 
        s_doneMult <= '0';
        doneMult <= s_doneMult;
        s_z<=0;
    else
    if(s_readEnb_d = '1') then
         s_tempOut(s_z) <= s_temp(0,0) + s_temp(0,1) + s_temp(0,2) + s_temp(1,0) + s_temp(1,1) + s_temp(1,2) + s_temp(2,0) +s_temp(2,1) + s_temp(2,2);
        if(s_z < (matRow*matCol)-1) then
            s_z <= s_z + 1;
            s_doneMult <= '0';
            
        else 
            s_z <= 0;
            s_doneMult <= '1';                

        end if;  
        end if;        
      end if;
end if;  

--s_doneMult <= d_doneMult;
--doneMult <= d_doneMult;

if(s_doneMult = '1') then
    for k in 0 to (matRow*matCol)-1 loop
        s_tempOut(k) <= (x"00"); 
    end loop;
    
    doneMult <= s_doneMult;
end if;
end process;         ---- convolveAdd Process ends here



writeData <= s_temp;
outDataMultiply <= s_tempOut;

end Behavioral;
