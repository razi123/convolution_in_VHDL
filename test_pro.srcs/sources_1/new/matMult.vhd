----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.08.2019 15:51:36
-- Design Name: 
-- Module Name: matMult - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.multPkg.all;

entity matMult is
--generic(matRow :  integer := 4; 
--        matCol :  integer := 4;
--        kernRow : integer := 3;
--        kernCol : integer := 3;
--        kernStride : integer := 1 );

    Port ( clk : in STD_LOGIC;
           inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
          -- outMat : out t_2d_out( 0 to (((matRow-kernRow)/kernStride)+1)-1, 0 to (((matRow-kernRow)/kernStride)+1)-1);
           padDone : in STD_LOGIC:='0';
           doneBit : out STD_LOGIC:='0');
end matMult;

architecture Behavioral of matMult is
constant  clkPeriod : time := 20ns;

type state_type is (rstState,zeroState,padState,multState, addState);  --type of state machine.
signal current_s,next_s: state_type;

signal rst : STD_LOGIC:= '0';
signal matKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);

signal filtKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1) := (("0001","0000","0000"),("0000","0001","0000"),("0000","0000","0001"));
signal doneSig: STD_LOGIC := '0';
signal donePad : STD_LOGIC := '0';  
signal m,n : integer range 0 to (((matRow-kernRow)/kernStride)+1)-1 := 0; 
--signal z : integer range 0 to 3; 
signal z : integer range 0 to (((matRow - kernRow)/kernStride)+1) * (((matRow-kernRow)/kernStride)+1) -1;
signal addEnb, multEnb: STD_LOGIC := '0';


--signal tempOut: t_2d_out(0 to 3); 
--signal tempOut: t_2d_out(0 to (((matRow-kernRow)/kernStride)+1) * (((matRow-kernRow)/kernStride)+1) -1); 
signal tempOut: t_2d_out(0 to 15);
signal temp: t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1) := (("00000000","00000000","00000000"),("00000000","00000000","00000000"),("00000000","00000000","00000000"));
--signal inpMat : t_2d_array(0 to matRow-1, 0 to matcol-1):= (("0001","0010","0011","0100"),("0001","0010","0011","0100"),("0001","0010","0011","0100"),
--                 ("0001","0010","0011","0100"));     

signal padInp : t_2d_array(-1 to 4, -1 to 4); 
signal zeroMat : STD_LOGIC := '0';
signal doneMult : STD_LOGIC := '0';

-- ************************************************* ARCHITECTURE********************************************************
begin

process (clk)
begin
 if (rst = '1') then
  current_s <= rstState;  --default state on reset.
elsif (rising_edge(clk)) then
  current_s <= next_s;   --state change.
end if;
end process;


-- state machine process

process(clk,rst) 
begin 

case current_s is
    when rstState =>
    if (rst = '0') then
        next_s <= zeroState;
    else
        next_s <= rstState;
       
    end if;
    
     when zeroState =>
     if (rst = '0' and zeroMat = '1') then
        next_s <= padState;
           
     elsif (rst = '0' and zeroMat = '0') then
        next_s <= zeroState;
     elsif (rst = '0' and doneBit = '1') then
        next_s <= rstState; 
     else
         next_s <= rstState;
     end if;
    
     when padState =>
     if (rst = '0' and donePad = '1') then
        next_s <= multState; 
     elsif (rst = '0' and donePad = '0') then
        next_s <= padState;
     
     elsif (rst = '0' and doneBit = '1') then
        next_s <= rstState;  
     else
        next_s <= rstState;
     end if;
         
     when multState =>
     if (rst = '0' and doneMult = '1') then
        next_s <= addState;
        
     elsif (rst = '0' and doneMult = '0') then
        next_s <= multState;
     
     elsif (rst = '0' and doneBit = '1') then
  
        next_s <= rstState;
     
     else 
        next_s <= rstState; 
     end if;
        
        
     when addState =>
     if (rst = '0' and doneBit = '1') then
   
        next_s <= rstState;
        
     elsif (rst = '0' and doneBit = '0') then
  
        next_s <= multState;
     else
        next_s <= rstState;
        
     end if;
 end case;     
end process;


-- Reset state process

process(clk) 
begin

if rising_edge(clk) then
if(current_s = zeroState) then
if doneBit = '0' then
for i in -1 to 4 loop
    for j in -1 to 4 loop
        padInp(i, j) <= "0000";
        if(i=4 and j=4) then
                zeroMat <= '1';
        else
                zeroMat <= '0';
        end if; 
    end loop;
  
end loop;
end if;
end if;
end if;

    
if rising_edge(clk) then
if(current_s = padState) then
for i in 0 to 3 loop
    for j in 0 to 3 loop
        padInp(i,j) <= inpMat(i,j);
        if(i=3 and j=3) then
                donePad <= '1';
        else
                donePad <= '0';
        end if;  
    end loop;
end loop;
end if;
end if;


--process(clk) is 
--begin   
   if rising_edge(clk) then
   if(current_s = multState) then
        
           -- for i in (kernRow-matRow) to 1 loop
           --     for j in (kernCol-matCol) to 1 loop
            for i in 0 to 2 loop
                for j in 0 to 2 loop
                    matKernal(i,j) <= padInp(i + m -1 ,j + n -1);
                    if(i=2 and j=2) then
                        multEnb <= '1';
                    else
                        multEnb <= '0';
                    end if;  
                end loop; 
            end loop; 
       
    end if;
   end if;
    
end process;   
  

process(clk) is

begin
if rising_edge(clk) then     

--if(current_s = s2) then
    if(multEnb ='1') then
        for i in 0 to 2 loop 
            for j in 0 to 2 loop
        
                temp(i,j) <=  matKernal(i,j) * filtKernal(i,j);
                if(i=2 and j=2) then
                doneMult <= '1';
                else
                doneMult <= '0';
                end if;  
        end loop;
        end loop;
                    
end if;
    end if;
end process;
  
  
process(clk) is
begin 

if rising_edge(clk) then
   if(current_s = addState) then 
        tempOut(z) <= temp(0,0) + temp(0,1) + temp(0,2) + temp(1,0) + temp(1,1) + temp(1,2) + temp(2,0) +temp(2,1) + temp(2,2);
        --doneSig <= '1';
        if(z < 15) then
            z <= z + 1;
            doneBit <= '0';
            if(n < 3)  then      -- ((matRow-kernRow)/kernStride)) then --(matRow-kernRow)) then   -- n< 1
                n <= n + 1;
                m <= m;
            elsif(m < 3) then --((matCol-kernCol)/kernStride)) then  -- (matRow-kernRow)) then -- -- m <1
                n <= 0;
                m <= m + 1;
            else
                n <= 0;
                m <= 0;
            end if;
        else
            z<= 0;
            n <= 0;
            m <= 0;
            tempOut <= (x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00") after clkPeriod /2;
            doneBit <= '1';
        end if;
     
    end if;
    end if;
              

end process;
   
    


end Behavioral;
