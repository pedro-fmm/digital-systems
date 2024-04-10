library ieee;
use ieee.std_logic_1164.all;
use work.BC_State.all;

entity somadorMulticiclo4T is
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
end entity;

architecture descricaoEstrutural of somadorMulticiclo4T is
	component blocoOperativo4T is
		generic(width_ent: positive;
			width_n: positive);
		port(
			-- control in
			clock, reset: in std_logic;
			-- control in (command signals from BC)
			scont, ccont, zAC, cAC, cT: in std_logic;		
			-- control out (status signals to BC)
			zero, ov: out std_logic;
			-- data in
			ent: in std_logic_vector(width_ent-1 downto 0);
			n: in std_logic_vector(width_n-1 downto 0);
			-- data out
			soma: out std_logic_vector(width_ent-1 downto 0) 
		);
	end component;
	component blocoControle4T is
		port(
			-- control in
			clock, reset, iniciar: in std_logic;
			-- control in (status signals from BC)
			zero, ov: in std_logic;
			-- control out 
			erro, pronto: out std_logic;
			-- control out (command signals to BC)
			scont, ccont, zAC, cAC, cT: out std_logic;
			-- Tests
			stateBC: out State
		);
	end component; 
	-- COMPLETE COM EVENTUAIS SINAIS INTERNOS
	signal scont, ccont, zAC, cAC, cT: std_logic;		
	signal zero, ov: std_logic;
	signal resultado: std_logic_vector(width_ent-1 downto 0);

begin
    -- COMPLETE COM EVENTUAIS COMANDOS CONCORRENTES
    -- COMPLETE OS COMANDOS DE INSTANCIACAO ABAIXO
	BO: blocoOperativo4T 
			generic map(
                width_ent=>width_ent, 
                width_n=>width_n
                )
			port map(
                clock=>ck,
                reset=>reset, 
				scont=>scont, 
                ccont=>ccont, 
                zAC=>zAC, 
                cAC=>cAC, 
                cT=>cT,
				zero=>zero, 
                ov=>ov,
				ent=>ent,
                n=>n, 
				soma=>resultado
            );
            
	BC: blocoControle4T 
            port map(
                clock=>ck, 
                reset=>reset, 
                iniciar=>iniciar,
				zero=>zero, 
                ov=>ov,
				erro=>erro, 
                pronto=>pronto,
				scont=>scont, 
                ccont=>ccont, 
                zAC=>zAC, 
                cAC=>cAC, 
                cT=>cT,
				stateBC=>stateBC
                );

	soma <= resultado;
end architecture;