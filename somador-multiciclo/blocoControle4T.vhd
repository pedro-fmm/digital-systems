library ieee;
use ieee.std_logic_1164.all;
use work.BC_State.all;

entity blocoControle4T is
	port(
		-- control in
		clock, reset, iniciar: in std_logic;
		-- control in (status signals from BC)
		zero, ov: in std_logic;
		- - control out 
		erro, pronto: out std_logic;
		-- control out (command signals to BC)
		scont, ccont, zAC, cAC, cT: out std_logic;
		-- Tests
		stateBC: out State
	);
end entity;

architecture descricaoComportamental of blocoControle4T is
    -- não acrescente nada aqui. State está definido no package work.BC_State
    signal nextState, currentState: State;
begin
    -- next-state logic (nao exclua e nem mude esta linha)
    -- COMPLETE

	process(currentState, zero, ov, iniciar)
	begin
		nextState <= currentState;
		case currentState is
			when S0 =>
				if iniciar = '0' then
					nextState <= S0;
				else
					nextState <= S1;
				end if;
			when S1 =>
				nextState <= S2;
			when S2 =>
				if zero = '1' then
					nextState <= S0;
				else
					nextState <= S3;
				end if;
			when S3 =>
				if ov = '1' then
					nextState <= E;
				else
					nextState <= S2;
				end if;
			when E =>	
				if iniciar = '0' then
					nextState <= E;
				else
					nextState <= S1;
				end if;
		end case;				
	end process;

	-- memory element --state register--  (nao exclua e nem mude esta linha)
    -- COMPLETE
	process(clock, reset)
	begin
		if reset = '1' then
			currentState <= S0;
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;

	-- output logic  (nao exclua e nem mude esta linha)
	-- COMPLETE
	stateBC <= currentState;
	pronto <= '1' when currentState = S0 or currentState = E else '0';
	erro <= '1' when currentState = E else '0';
	zAC <= '1' when currentState = S1 else '0';
	cAC <= '1' when currentState = S1 or currentState = S3 else '0';
	cT <= '1' when currentState = S1 or currentState = S3 else '0';
	scont <= '1' when currentState = S1 else '0';
	ccont <= '1' when currentState = S1 or currentState = S3 else '0';
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
