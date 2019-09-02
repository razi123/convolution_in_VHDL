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
           doneBit : out STD_LOGIC:='0');
end matMult;

architecture Behavioral of matMult is
constant  clkPeriod : time := 20ns;

--type t_2d_array is array(integer range <>, integer range <>) of  STD_LOGIC_VECTOR(3 downto 0);
--type t_2d_kernal is array(integer range <> , integer range <>) of STD_LOGIC_VECTOR(3 downto 0);
--type t_2d_out is array(integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
--type t_tempKernal2d is array(integer range <>, integer range <>) of STD_LOGIC_VECTOR(7 downto 0);



signal matKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);

signal filtKernal : t_2d_kernal(0 to kernRow-1, 0 to kernCol-1) := (("0001","0000","0000"),("0000","0001","0000"),("0000","0000","0001"));
signal doneSig: STD_LOGIC := '0';
signal m,n : integer range 0 to (((matRow-kernRow)/kernStride)+1)-1 := 0; 
--signal z : integer range 0 to 3; 
signal z : integer range 0 to (((matRow - kernRow)/kernStride)+1) * (((matRow-kernRow)/kernStride)+1) -1;
signal addEnb, multEnb: integer :=0;


--signal tempOut: t_2d_out(0 to 3); 
signal tempOut: t_2d_out(0 to (((matRow-kernRow)/kernStride)+1) * (((matRow-kernRow)/kernStride)+1) -1); 
signal temp: t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1) := (("00000000","00000000","00000000"),("00000000","00000000","00000000"),("00000000","00000000","00000000"));
--signal inpMat : t_2d_array(0 to matRow-1, 0 to matcol-1):= (("0001","0010","0011","0100"),("0001","0010","0011","0100"),("0001","0010","0011","0100"),
--                 ("0001","0010","0011","0100"));     


begin
      
process(clk)
    begin
    if rising_edge(clk) then
        doneSig <= '0';
            for i in 0 to kernRow-1 loop
                for j in 0 to kernCol-1 loop
                    matKernal(i,j) <= inpMat(i+m ,j+n);
                 end loop; 
            end loop;
    end if;
 end process ;   
  

process(clk) is

begin
 if rising_edge(clk) then     
    multEnb <= 1;
    doneBit <= '0';
    if(multEnb =1) then
        temp(0,0) <=  matKernal(0,0) * filtKernal(0,0); 
        temp(0,1) <=  matKernal(0,1) * filtKernal(0,1);
        temp(0,2) <=  matKernal(0,2) * filtKernal(0,2);
                    
        temp(1,0) <=  matKernal(1,0) * filtKernal(1,0); 
        temp(1,1) <=  matKernal(1,1) * filtKernal(1,1);
        temp(1,2) <=  matKernal(1,2) * filtKernal(1,2);
                   
        temp(2,0) <=  matKernal(2,0) * filtKernal(2,0); 
        temp(2,1) <=  matKernal(2,1) * filtKernal(2,1);
        temp(2,2) <=  matKernal(2,2) * filtKernal(2,2);
        addEnb <= 1;            
    end if;
                   
    if(addEnb = 1) then
        tempOut(z) <= temp(0,0) + temp(0,1) + temp(0,2) + temp(1,0) + temp(1,1) + temp(1,2) + temp(2,0) +temp(2,1) + temp(2,2);
        doneSig <= '1';
        multEnb <= 0 ;
        addEnb <= 0;
        
        if(z <= ((((matRow-kernRow)/kernStride)+1) * (((matRow-kernRow)/kernStride)+1)) -2) then -- (matRow-kernRow)+1) then -- -- z<=2
             z <= z+1; 
        else
            doneBit <= '1';
            z <= 0; 
            --tempOut <= (x"00",x"00",x"00",x"00") after clkPeriod /2;
            tempOut <= (x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00") after clkPeriod /2;
        end if;
       
        if(n <((matRow-kernRow)/kernStride)) then --(matRow-kernRow)) then   -- n< 1
            n <= n + 1;
            m <= m;
        elsif(m < ((matCol-kernCol)/kernStride)) then  -- (matRow-kernRow)) then -- -- m <1
            n <= 0;
            m <= m + 1;
        else
            n <= 0;
            m <= 0;
        end if;
              
    end if;
end if;

end process;
   
    


end Behavioral;
