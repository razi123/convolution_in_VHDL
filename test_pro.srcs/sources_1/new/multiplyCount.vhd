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

entity multiplyCount is
    port(clk: in STD_LOGIC;
         clkEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         readEnb: in STD_LOGIC := '0';
         --readData : in t_2d_array(0 to 3, 0 to 3) := ((x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"),(x"0",x"0",x"0",x"0"));
         readData : in t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
         doneMult : out STD_LOGIC := '0';
         --writeData : out t_2d_kernal(0 to kernRow-1, 0 to kernCol-1)
         writeData : out t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1);
         cntEnb : in STD_LOGIC := '0';
         colDone : out STD_LOGIC := '0';
         cntRow : out integer range 0 to 2;
         cntCol : out integer range 0 to 2);
end multiplyCount;

architecture Behavioral of multiplyCount is
signal temp: t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1) := (("00000000","00000000","00000000"),("00000000","00000000","00000000"),("00000000","00000000","00000000"));
signal filtKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1) := (("0001","0000","0000"),("0000","0001","0000"),("0000","0000","0001"));
signal doneMultSig : STD_LOGIC :='0';
signal z : integer range 0 to 15 := 0;
signal tempOut: t_2d_out(0 to 15);

constant  clkPeriod : time := 20ns;

signal n : integer range 0 to 3 :=0;
signal m : integer range 0 to 3 :=0;

begin

process(clk) is

begin
if rising_edge(clk) then     
    
    if(readEnb = '1') then
        for i in 0 to 2 loop 
            for j in 0 to 2 loop
        
                temp(i,j) <=  readData(i,j) * filtKernal(i,j);
                if(i=2 and j=2) then
                    doneMultSig <= '1';
                else
                    doneMultSig <= '0';
                end if;  
        end loop;
        end loop;
                    
    end if;
end if;
end process;

--process(clk) is
--begin
--if rising_edge(clk) then     

--    if(doneMultSig = '1') then
--        tempOut(z) <= temp(0,0) + temp(0,1) + temp(0,2) + temp(1,0) + temp(1,1) + temp(1,2) + temp(2,0) +temp(2,1) + temp(2,2);
--        if(z < 15) then
--            z <= z + 1;
--            doneMult <= '0';
            
--        else 
--            z <= 0;
--            doneMult <= '1'; 
--            --temp <= (("00000000","00000000","00000000"),("00000000","00000000","00000000"),("00000000","00000000","00000000"));
--            tempOut <= (x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00"); 
--        end if;          
--      end if;
--end if;
--end process;
--writeData <= temp;



process(clk) is
begin 

if rising_edge(clk) then
    if(doneMultSig = '1') then
        tempOut(z) <= temp(0,0) + temp(0,1) + temp(0,2) + temp(1,0) + temp(1,1) + temp(1,2) + temp(2,0) +temp(2,1) + temp(2,2);
        --doneSig <= '1';
        if(z < 15) then
            z <= z + 1;
            doneMult <= '0';
            if(n < 3)  then      -- ((matRow-kernRow)/kernStride)) then --(matRow-kernRow)) then   -- n< 1
                n <= n + 1;
                m <= m;
                colDone <= '0';
            elsif(m < 3) then --((matCol-kernCol)/kernStride)) then  -- (matRow-kernRow)) then -- -- m <1
                n <= 0;
                m <= m + 1;
                colDone <= '0';
            else
                n <= 0;
                m <= 0;
                colDone <= '1';
            end if;
   
            
        else
            z<= 0;
            n <= 0;
            m <= 0;
            tempOut <= (x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00") after clkPeriod /2;
            doneMult <= '1';
        end if;
            
    end if;
end if;
              
cntRow <= n;
cntCol <= m;

end process;






end Behavioral;
