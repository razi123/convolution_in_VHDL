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

component matMult
--generic(matRow :  integer := 4; 
--        matCol :  integer := 4;
--        kernRow : integer := 3;
--        kernCol : integer := 3;
--        kernStride : integer :=1 ); 
        
Port (clk : in STD_LOGIC := '0';
          inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
          --outMat : out t_2d_out( 0 to 3);
           --res : in STD_LOGIC:='0';
           padDone : in STD_LOGIC:='0';
           doneBit : out STD_LOGIC:='0');
end component;

constant  clkPeriod : time := 20ns;
constant matRow : integer := 4;
constant matCol : integer := 4;
constant kernRow : integer := 3;
constant kernCol : integer := 3;
constant kernStride : integer := 1;

signal clkSignal : STD_LOGIC := '0';
signal inpMatSignal : t_2d_array(0 to matRow-1, 0 to matcol-1);
--signal outMatSignal : t_2d_out;
signal doneSignal, padDoneSignal : STD_LOGIC;
signal resSignal : STD_LOGIC;

begin

uut : matMult 
      --generic map (matRow => matRow, matCol => matCol,kernRow => kernRow, kernCol => kernCol,kernStride => kernStride)
      --Port map (clk => clkSignal, inpMat => inpMatSignal, outMat => outMatSignal, doneBit => doneSignal);
      Port map (clk => clkSignal,inpMat => inpMatSignal, padDone=> padDoneSignal, doneBit => doneSignal); --, res=>resSignal);

clockGenerator : process
begin
    clkSignal <= not clkSignal after clkPeriod /2 ;
    wait for clkPeriod/2;
end process;


stumuli: process
begin
--inpMatSignal <= ((std_logic_vector(unsigned(1,8)), std_logic_vector(unsigned(2,8)), std_logic_vector(unsigned(3,8)), std_logic_vector(unsigned(4,8))) ,
--                (std_logic_vector(unsigned(1,8)), std_logic_vector(unsigned(2,8)), std_logic_vector(unsigned(3,8)), std_logic_vector(unsigned(4,8))) ,
--                (std_logic_vector(unsigned(1,8)), std_logic_vector(unsigned(2,8)), std_logic_vector(unsigned(3,8)), std_logic_vector(unsigned(4,8))) ,
--                (std_logic_vector(unsigned(1,8)), std_logic_vector(unsigned(2,8)), std_logic_vector(unsigned(3,8)), std_logic_vector(unsigned(4,8))));


-- _______________________ input for 4x4 _________________________________
--padDoneSignal <= '0';
--resSignal <= '1';
inpMatSignal <= (("0001","0010","0011","0100"),("0001","0010","0011","0100"),("0001","0010","0011","0100"),
                 ("0001","0010","0011","0100"));     
                 
wait until doneSignal='1'; 

--padDoneSignal <= '0';
inpMatSignal <= (("0001","0011","0011","0100"),("0001","0011","0011","0100"),("0001","0011","0011","0100"),
                 ("0001","0011","0011","0100"));    
wait until doneSignal='1';           


-- _______________________ input for 5x5 _________________________________     

--inpMatSignal <= (("0001","0010","0011","0100", "0101"),("0001","0010","0011","0100", "0101"),("0001","0010","0011","0100", "0101"),
--                 ("0001","0010","0011","0100", "0101"), ("0001","0010","0011","0100", "0101"));     
--wait until doneSignal='1'; 

--inpMatSignal <= (("0001","0011","0011","0011", "0001"),("0001","0011","0011","0011", "0001"),("0001","0011","0011","0011", "0001"),
--                 ("0001","0011","0011","0011", "0001"), ("0001","0011","0011","0011", "0001"));  
--wait until doneSignal='1';  


end process;

end Behavioral;
