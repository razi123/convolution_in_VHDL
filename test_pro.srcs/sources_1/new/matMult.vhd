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

    Port ( clk : in STD_LOGIC;
           clkEnb : in STD_LOGIC :='0';
           readEnb: in STD_LOGIC :='0';
           inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
           rst : in STD_LOGIC:='0';
           outMat : out t_2d_out(0 to (matRow*matCol)-1);
           doneBit : out STD_LOGIC:='0');
end matMult;

architecture Behavioral of matMult is

constant  clkPeriod : time := 20ns;
signal writeEnb : STD_LOGIC:= '0';
signal outData :  t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);

signal cntEnbSig : STD_LOGIC:= '0';
signal cntRow : integer range 0 to (((matRow-kernRow)/kernStride)+1)-1 ;
signal cntCol : integer range 0 to (((matRow-kernRow)/kernStride)+1)-1 ;
--signal cntRow : integer range 0 to ((matRow-kernRow)/(kernStride+1))+ 1 ;
--signal cntCol : integer range 0 to ((matRow-kernCol)/(kernStride+1))+ 1 ;

-- ---------------------------------------------------------------------------------------------------------------------
--                                         SIGNAL DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------

signal s_tempMult: t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1) := (("00000000","00000000","00000000"),("00000000","00000000","00000000"),("00000000","00000000","00000000")); 
signal s_colDone, s_doneBit: STD_LOGIC := '0';

-- ---------------------------------------------------------------------------------------------------------------------
--                                          COMPONENTS DECLERATION 
-- ---------------------------------------------------------------------------------------------------------------------
component BufferInput
    port(clk: in STD_LOGIC;
         clkEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         inpMat : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
         readData : in t_2d_array(0 to matRow-1, 0 to matcol-1); 
         writeEnb : out STD_LOGIC := '0';
         cntEnb : out STD_LOGIC := '0';
         cntRow : in integer range 0 to (((matRow-kernRow)/kernStride)+1)-1  := 0;
         cntCol : in integer range 0 to (((matCol-kernRow)/kernStride)+1)-1  := 0;
         writeData : out t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
         doneBuff : in STD_LOGIC := '0');
end component;

component rowCount
    port(clk: in STD_LOGIC;
         cntEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         cntRow : out integer range 0 to (((matRow-kernRow)/kernStride)+1)-1  := 0;
         cntCol : out integer range 0 to (((matCol-kernRow)/kernStride)+1)-1  := 0;
       --  cntRow : out integer range 0 to (((matRow-kernRow)/(kernStride+1)-1  := 0;
       --  cntCol : out integer range 0 to (((matCol-kernRow)/kernStride)+1)-1  := 0;
         colDone : out STD_LOGIC := '0');
    
end component;

component Multiply
    port(clk: in STD_LOGIC;
         clkEnb : in STD_LOGIC := '0';
         rst : in STD_LOGIC := '0';
         readEnb: in STD_LOGIC := '0';
         readData : in t_2d_kernal(0 to kernRow-1, 0 to kernCol-1);
         doneMult : out STD_LOGIC := '0';
         writeData : out t_tempKernal2d(0 to kernRow-1, 0 to kernCol-1);
         outDataMultiply : out t_2d_out(0 to (matRow*matCol)-1));
end component;


-- ---------------------------------------------------------------------------------------------------------------------
--                                         ARCHITECTURE BEGINS 
-- ---------------------------------------------------------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------------------------------------------------------
--                                          COMPONENTS INSTANTIATION 
-- ---------------------------------------------------------------------------------------------------------------------

BUFFER_INPUT : BufferInput
port map(clk => clk, 
        clkEnb => clkEnb, 
        rst => rst, 
        inpMat => inpMat,
        readData => inpMat,
        writeEnb => writeEnb, 
        writeData => outData,
        cntRow => cntRow,
        cntCol => cntCol,
        cntEnb =>cntEnbSig,
        doneBuff => s_doneBit);
 
 
ROW_COUNTER : rowCount 
port map(clk => clk,
              cntEnb => cntEnbSig, 
              rst => rst,
              cntRow => cntRow, 
              cntCol => cntCol,
              colDone => s_colDone);       
        

MULTILY : Multiply
    port map(clk => clk, 
         clkEnb => clkEnb, 
         rst => rst, 
         readEnb => writeEnb,
         readData => outData, 
         doneMult => s_doneBit, 
         writeData => s_tempMult,
         outDataMultiply => outMat);
 
 
 
doneBit <= s_doneBit;         
         
end Behavioral;              
              







