----------------------------------------------------------------------------------
-- Company:     Federal University of Santa Catarina - UFSC
-- Engineer:    Prof. Dr. Eng. Rafael Luiz Cancian
-- Create Date: 2021
-- Design Name: 
-- Module Name:    addersubtractor
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--arch 
use ieee.numeric_std.all;

entity addersubtractor is
	generic(	N: positive;
			isAdder: boolean := false;
			isSubtractor: boolean := false;
-- 			generateCout: boolean := false;
			generateOvf: boolean := false
-- 			fixedSecodOperand: integer := 0
    );
	port(	
		a, b: in std_logic_vector(N-1 downto 0);
		op: in std_logic;
		result: out std_logic_vector(N-1 downto 0);
		ovf, cout: out std_logic );
end entity;

architecture arch1 of addersubtractor is
	signal carry: std_logic_vector(N downto 0);
	signal operandB: std_logic_vector(N-1 downto 0);
	signal secondOperand: std_logic_vector(N-1 downto 0);
begin
-- 	fixed: if fixedSecodOperand /= 0 generate 
-- 		secondOperand <= std_logic_vector(to_unsigned(fixedSecodOperand, secondOperand'length));
-- 	end generate;
-- 	notfixed: if  fixedSecodOperand = 0 generate
		secondOperand <= b;
-- 	end generate;
	gera: for i in result'range generate
		result(i) <= carry(i) xor a(i) xor operandB(i);
		carry(i+1) <= (carry(i) and a(i)) or (carry(i) and operandB(i)) or (a(i) and operandB(i));
	end generate;
	generateAdder: if isAdder and not isSubtractor generate
		carry(0) <= '0';
		operandB <= secondOperand;
	end generate;
	generateSubtractor: if not isAdder and isSubtractor generate
		carry(0) <= '1';
		operandB <= not secondOperand;
	end generate;
	generateBoth: if (isAdder and isSubtractor) or not(isAdder or isSubtractor) generate
		carry(0) <= op;
		operandB <= secondOperand when op='0' else not secondOperand;
	end generate;
	generateOverflow: if generateOvf generate
		ovf <= carry(N) xor carry(N-1);
	end generate;
-- 	generateCarryOut: if generateCout generate
		cout <= carry(N);
-- 	end generate;
end architecture;
