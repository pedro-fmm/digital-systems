library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addersubtractor is
	generic(	N: positive;
			isAdder: boolean := false;
			isSubtractor: boolean := false;
			generateCout: boolean := true;
			generateOvf: boolean := false);
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
    
	gera: for i in result'range generate
		result(i) <= carry(i) xor a(i) xor operandB(i);
		carry(i+1) <= (carry(i) and a(i)) or (carry(i) and operandB(i)) or (a(i) and operandB(i));
	end generate;
	generateAdder: if isAdder and not isSubtractor generate
		carry(0) <= '0';
		operandB <= b;
	end generate;
	generateSubtractor: if not isAdder and isSubtractor generate
		carry(0) <= '1';
		operandB <= not b;
	end generate;
	generateBoth: if (isAdder and isSubtractor) or not(isAdder or isSubtractor) generate
		carry(0) <= op;
		operandB <= b when op='0' else not b;
	end generate;
	generateOverflow: if generateOvf generate
		ovf <= carry(N) xor carry(N-1);
	end generate;
	generateCarryOut: if generateCout generate
		cout <= carry(N);
	end generate;
end architecture;