library ieee;
use ieee.std_logic_1164.all;

entity divisaoInt is
    generic(
        largDividendo: integer;
        largDivisor: integer
        );
    port (  
        clock, iniciar: in std_logic;
        dividendo: in std_logic_vector(largDividendo-1 downto 0);
        divisor: in std_logic_vector(largDivisor-1 downto 0);
        quociente: out std_logic_vector(largDividendo-1 downto 0);
        resto: out std_logic_vector(largDivisor-1 downto 0);
        retorno: out std_logic
        );
end entity;

architecture SD of divisaoInt is

	signal quociente0, resto_igual_dividendo, resto_igual_resto_menos_dividendo, quociente_mais_um, resto_maior_divisor : std_logic;

	component blocooperativo is
		generic(
			largDividendo: integer;
			largDivisor: integer
		);
	port(
			clock, reset, quociente0, resto_igual_dividendo, resto_igual_resto_menos_dividendo, quociente_mais_um : in std_logic;
			
			dividendo: in std_logic_vector(largDividendo-1 downto 0);
			divisor: in std_logic_vector(largDivisor-1 downto 0);
			
			quociente: out std_logic_vector(largDividendo-1 downto 0);
			resto: out std_logic_vector(largDivisor-1 downto 0);
			resto_maior_divisor : out std_logic
		);
	end component;
	
	component blococontrole is
		port(
			clock, reset, iniciar, 
			resto_maior_divisor : in std_logic;
			
			quociente0, resto_igual_dividendo, resto_igual_resto_menos_dividendo, quociente_mais_um, retorno: out std_logic
		);
	end component;

begin
    
    BO: blocooperativo
			generic map(
				largDividendo => largDividendo, 
				largDivisor => largDivisor
				)
			port map(
				clock => clock,
				reset => reset, 
				quociente0 => quociente0, 
				resto_igual_dividendo => resto_igual_dividendo, 
				resto_igual_resto_menos_dividendo => resto_igual_resto_menos_dividendo, 
				quociente_mais_um => quociente_mais_um, 
				dividendo => dividendo, 
				divisor => divisor, 
				quociente => quociente, 
				resto => resto, 
				resto_maior_divisor => resto_maior_divisor
			);

			
	BC: blococontrole
			port map(
				clock => clock, 
				reset => reset, 
				iniciar => iniciar, 
				resto_maior_divisor => resto_maior_divisor, 
				quociente0 => quociente0, 
				resto_igual_dividendo => resto_igual_dividendo, 
				resto_igual_resto_menos_dividendo => resto_igual_resto_menos_dividendo, 
				quociente_mais_um => quociente_mais_um, retorno => retorno
			);

end architecture;
