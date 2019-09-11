----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2019 12:32:10
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity colCount is
 port(clk: in STD_LOGIC;
      cntEnb : in STD_LOGIC := '0';
      rst : in STD_LOGIC := '0';
      --readData : in t_2d_array(0 to 3, 0 to 3) := ((x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"));
      --writeEnb : in STD_LOGIC := '0';
      --writeCnt : out t_2d_kernal(0 to kernRow-1, 0 to kernCol-1)
      cntCol : out integer range 0 to 2;
      colDone : out STD_LOGIC := '0');
      
end colCount;

architecture Behavioral of colCount is

signal m : integer range 0 to 3 :=0;
begin

process(clk,rst) is
begin 
if rising_edge(clk) then
if cntEnb ='1' then
            if(m < 3)  then      -- ((matRow-kernRow)/kernStride)) then --(matRow-kernRow)) then   -- n< 1
                m <= m + 1;
                colDone <= '0';
            elsif(m > 2) then --((matCol-kernCol)/kernStride)) then  -- (matRow-kernRow)) then -- -- m <1
                m <= 0;
                colDone <= '1';
            else 
                m<= m;
            end if;
    end if;
end if;

end process;
 cntCol <= m;
end Behavioral;