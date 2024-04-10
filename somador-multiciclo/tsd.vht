-- MAIN_TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use ieee.math_real.all;
use std.textio.all;
use work.BC_State.all;

entity tsd is
    generic(
        LATENCY: time := 50 ns; -- AJUSTE ESSE VALOR CONFORME O TIMING ANALIZER E O ENUNCIADO
        MAXPULSES: integer := 100;
        WIDTH_ENT: positive := 10;
        WIDTH_N: positive := 6
    );
end entity;

architecture arch_test of tsd is

function to_string (arg : std_logic_vector) return string is
  variable result : string (1 to arg'length);
  variable v : std_logic_vector (result'range) := arg;
begin
  for i in result'range loop
    case v(i) is
      when 'U' => result(i) := 'U';
      when 'X' => result(i) := 'X';
      when '0' => result(i) := '0';
      when '1' => result(i) := '1';
      when 'Z' => result(i) := 'Z';
      when 'W' => result(i) := 'W';
      when 'L' => result(i) := 'L';
      when 'H' => result(i) := 'H';
      when '-' => result(i) := '-';
    end case;
  end loop;
  return result;
end function;

component somadorMulticiclo4T is
	generic(width_ent: positive := 8;
			width_n: positive := 4);
	port(
		-- control in
		ck, reset, iniciar: in std_logic;
		-- control out
		erro, pronto: out std_logic;
		-- data in
		ent: in std_logic_vector(width_ent-1 downto 0);
		n: in std_logic_vector(width_n-1 downto 0);
		-- data out
		soma: out std_logic_vector(width_ent-1 downto 0);
		-- Tests
		stateBC: out State
	);
end component;

signal clock, reset, iniciar: std_logic;
signal erro, pronto: std_logic;
signal ent: std_logic_vector(WIDTH_ENT-1 downto 0);
signal n: std_logic_vector(WIDTH_N-1 downto 0);
signal soma: std_logic_vector(WIDTH_ENT-1 downto 0);
signal stateBC: State;
--
signal pulse: integer := 0;
signal step: integer := 0;
begin
	uut: somadorMulticiclo4T     generic map (WIDTH_ENT, WIDTH_N) port map(clock, reset, iniciar, erro,    pronto,    ent, n, soma,    stateBC);

	setaSentradas: process is
        variable errors: integer := 0;
		variable seed1: positive := 1;
        variable seed2: positive := 1;
		variable rand1: integer;
		variable x : real;
	begin
        if step = 0 then
            -- falling edge
          clock <= '0';
          step <= 1;
        elsif step = 1 then
            -- set inputs
            
            -- COMPLETE COM OS ESTIMULOS DE ENTRADA

            step <= 2;
        elsif step = 2 then
            -- wait before rising edge
            step <= 3;
        elsif step = 3 then
            -- rising edge
		    clock <= '1';
            step <= 4;
        elsif step = 4 then
            -- show inputs and outputs
            if pulse = 0 then
                report  "reset, iniciar, ent, n ==> soma, pronto, erro, (State) (S4=E)";
            end if;
            report  "" & std_logic'image(reset) &
                ", " & std_logic'image(iniciar) &
            	", " & integer'image(to_integer(unsigned(ent))) &
            	", " & integer'image(to_integer(unsigned(n))) &
	            " ==> " &
            	"" & integer'image(to_integer(unsigned(soma))) &
                ", " & std_logic'image(pronto) &
                ", " & std_logic'image(erro) & 
                ", (S" & integer'image(State'pos(stateBC)) & ")";
		    if pulse > MAXPULSES then
			    report "DigitalSystem Simulation completed";
			    wait; 
		    end if;
		    pulse <= pulse + 1;
            step <= 0;
        end if;
        wait for LATENCY / 5;
    end process;
	
end architecture;
