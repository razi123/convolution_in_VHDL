
-- ******************************************************BUFFER START********************************************************************

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2019 11:36:02
-- Design Name: 
-- Module Name: BufferInput - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.multPkg.all;

entity BufferInput is
    port(clk: in STD_LOGIC;
         clkEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
         readData : in t_2d_array(0 to matRow-1, 0 to matCol-1);
         writeEnb : out STD_LOGIC := '0';
         writeData : out t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
         cntEnb : out STD_LOGIC := '0';
         cntRow : in integer range 0 to kernRow-1 := 0;
         cntCol : in integer range 0 to kernCol-1 := 0;
         doneBuff : in STD_LOGIC := '0');
end BufferInput;

architecture Behavioral of BufferInput is

-- ---------------------------------------------------------------------------------------------------------------------
--                                         SIGNAL DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------

signal s_padInp : t_2d_array(-1 to matRow, -1 to matCol);  
signal s_zeroMat : STD_LOGIC := '0';

signal s_matKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
signal s_fetchEnb: STD_LOGIC := '0';
signal s_writeEnb : STD_LOGIC :='0'; 
signal  d_writeEnb_d : STD_LOGIC;


-- ---------------------------------------------------------------------------------------------------------------------
--                                         ARCHITECTURE BEGINS 
-- ---------------------------------------------------------------------------------------------------------------------

begin
   
zeroPad: process(clk,rst) 

begin 

if rising_edge(clk)then
if rst ='1' then
s_zeroMat <= '0';
s_fetchEnb <= '0';

else
  s_fetchEnb <= '0';
  
    if clkEnb ='1' and s_zeroMat = '0' then
              
        for i in -1 to matRow loop
            for j in -1 to matCol loop
            s_padInp(i, j) <= "0000";
            
            end loop;
        end loop;
  
    s_zeroMat <= '1';

   else
     s_fetchEnb <= '1';   
         for i in 0 to matRow-1 loop
            for j in 0 to matCol-1 loop
                s_padInp(i,j) <= inpMat(i,j);
                
            end loop;
         end loop;
    end if;
    
end if;
end if; 

end process;  ---- zeroPad Process ends here


fetchMatrix_3x3 : process(clk,rst) is 
begin   
  if rising_edge(clk)  then
    if rst ='1' then
        s_writeEnb<='0';
        cntEnb<='0';
    else
        cntEnb<='0';
        s_writeEnb<='0';
        if s_fetchEnb = '1' then
    
--        if cntCol > 0 then
--            cntEnb <= '0';
--        end if;

          cntEnb <= '1';
          s_writeEnb <= '1'; 
                for i in 0 to 2 loop
                    for j in 0 to 2 loop
                     s_matKernal(i,j) <= s_padInp(i + cntCol -1 ,j + cntRow -1);  -- orignal
                     -- s_matKernal(i,j) <= s_padInp(j + cntCol -1 ,i + cntRow -1); 
                    -- s_matKernal(i,j) <= s_padInp(i + cntRow -1,j + cntCol -1);   --upside down read l2r
                    --  s_matKernal(i,j) <= s_padInp(j + cntRow -1,i + cntCol -1); -- upside down read t2b
                    end loop; 
                end loop; 
       
         end if;
    end if;
  
    d_writeEnb_d<=s_writeEnb;
    
   end if;
   
end process;  ---- fetchMatrix_3x3 Process ends here


writeEnb <= d_writeEnb_d;
writeData <= s_matKernal;

end Behavioral;