-- NAO ALTERE NADA NESTE ARQUIVO
-- ELE ESTÁ PRONTO E FUNCIONAL 
-- ESSE ARQUIVO É FORNECIDO APENAS PARA QUE VOCE POSSA COMPILAR O PROJETO NO QUARTUS

library ieee;
use ieee.std_logic_1164.all;

entity fulladder1bit is
	port(
		cin, a, b: in std_logic;
		sum: out std_logic;
		cout: out std_logic
	);
end entity;

architecture arch1 of fulladder1bit is
begin
	sum <= cin xor a xor b;
	cout <= (cin and a) or (cin and b) or (a and b);
end architecture;