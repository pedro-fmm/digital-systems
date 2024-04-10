library ieee;
use ieee.std_logic_1164.all;

entity blococontrole_sad is
	port(
		-- control in
		ck, reset, iniciar, 
		menor : in std_logic;
		-- data in
		-- controll out
		zi, ci, cpA, cpB, zsoma, csoma, csad_reg, 
		readmem, pronto: out std_logic
		-- data out
	);
end entity;

architecture archbehav of blococontrole_sad is
	type State is (S0, S1, S2, S3, S4, S5);
	signal nextState, currentState: State;
begin
	 nextState <= S0 when currentState = S5 or (currentState = S0 and iniciar = '0')
		else S1 when currentState = S0 and iniciar = '1'
		else S2 when currentState = S1 or currentState = S4
		else S3 when currentState = S2 and menor = '1'
		else S4 when currentState = S3
		else S5 when currentState = S2 and menor = '0';

	process (ck, reset) is
	 begin
		if reset = '1' then
			currentState <= S0;
		elsif rising_edge(ck) then
			currentState <= nextState;
		end if;	
	end process;
	
	pronto <= '1' when currentState = S0 else '0';
	
	zi <= '1' when currentState = S1 else '0';
	ci <= '1' when currentState = S1 or currentState = S4 else  '0';
	zsoma <= '1' when currentState = S1 else '0';
	csoma <= '1' when currentState = S1 or currentState = S4 else '0';
	
	readmem <= '1' when currentState = S3 else '0';
	cpA <= '1' when currentState = S3 else '0';
	cpB <= '1' when currentState = S3 else '0';
	
	csad_reg <= '1' when currentState = S5 else '0';
end architecture;