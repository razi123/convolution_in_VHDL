----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.08.2019 16:57:02
-- Design Name: 
-- Module Name: multPkg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package multPkg is 

constant matRow :  integer := 4; 
constant matCol :  integer := 4;
constant kernRow : integer := 3;
constant kernCol : integer := 3;
constant kernStride : integer := 1;


type t_2d_array is array(integer range <>, integer range <>) of  STD_LOGIC_VECTOR(3 downto 0);
type t_2d_kernal is array(integer range <> , integer range <>) of STD_LOGIC_VECTOR(3 downto 0);
type t_2d_out is array(integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
type t_tempKernal2d is array(integer range <>, integer range <>) of STD_LOGIC_VECTOR(7 downto 0);




end multPkg;




