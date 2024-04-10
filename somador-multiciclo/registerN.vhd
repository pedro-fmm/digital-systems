library ieee;
use ieee.std_logic_1164.all;
--arch
use ieee.numeric_std.all;

entity registerN is
	generic(	width: positive;
				generateLoad: boolean := true;
				resetValue: integer := 0
				);
	port(	-- control
			clock, reset, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end entity;

architecture behav0 of registerN is
subtype state is std_logic_vector(width-1 downto 0);
signal currentState, nextState: state;
	-- auxiliar signals
	signal tempLoad, tempClear: state;
begin
	-- next-state logic
	ifLoad: if generateLoad generate
		tempLoad <= input when load='1' else currentState;
	end generate;
	ifNotLoad: if not generateLoad generate
		tempLoad <= input;
	end generate;
	nextState <= tempLoad;	
	-- memory element
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= std_logic_vector(to_unsigned(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- output logic
	output <= currentState;
end architecture;