library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compare is
	generic(	width: positive;
				isSigned: boolean := false;
				generateEqual: boolean := false ;
				generateLessThan: boolean := false;
				useFixedSecodOperand: boolean := false;
				fixedSecodOperand: integer := 0 );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			lessThan, equal: out std_logic );
end entity;


architecture behav0 of compare is
begin
	if0: if generateEqual generate
		equal <= '1' when input0 = input1 else '0';
	end generate;
	if1: if generateLessThan generate
		if2: if isSigned generate
			lessThan <= '1' when signed(input0) < signed(input1) else '0';
		end generate;
		if3: if not isSigned generate
			lessThan <= '1' when unsigned(input0) < unsigned(input1) else '0';
		end generate;
	end generate;
end architecture;