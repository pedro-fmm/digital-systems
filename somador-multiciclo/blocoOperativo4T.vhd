library ieee;
use ieee.std_logic_1164.all;

entity blocoOperativo4T is
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
end entity;


architecture descricaoEstrutural of blocoOperativo4T is
	component multiplexer2x1 is
		generic (	width: positive );
		port(	input0, input1: in std_logic_vector(width-1 downto 0);
				sel: in std_logic;
				output: out std_logic_vector(width-1 downto 0) );
	end component;
	component addersubtractor is
		generic (	N: positive;
					isAdder: boolean;
					isSubtractor: boolean;
					generateOvf: boolean);
		port(	op: in std_logic;
				a, b: in std_logic_vector(N-1 downto 0);
				result: out std_logic_vector(N-1 downto 0);
				ovf, cout: out std_logic );
	end component;
	component registerN is
		generic(	width: natural;
					resetValue: integer := 0 );
		port(	-- control
				clock, reset, load: in std_logic;
				-- data
				input: in std_logic_vector(width-1 downto 0);
				output: out std_logic_vector(width-1 downto 0));
	end component;
	component compare is
		generic(	width: natural;
					isSigned: boolean;
					generateLessThan: boolean;
					generateEqual: boolean );
		port(	input0, input1: in std_logic_vector(width-1 downto 0);
				lessThan, equal: out std_logic );
	end component;
	-- COMPLETE COM EVENTUAIS SINAIS INTERNOS
    signal mCont, sContador, contMenosUm: std_logic_vector(width_n-1 downto 0);
    signal sAc, sSoma, mAc, sT: std_logic_vector(width_ent-1 downto 0);
begin
	-- COMPLETE COM EVENTUAIS COMANDOS CONCORRENTES
    -- COMPLETE OS COMANDOS DE INSTANCIACAO ABAIXO
	mux0: multiplexer2x1 
			generic map(
                width=>width_n
                )
			port map(
                input0=>contMenosUm, 
                input1=>n, 
                sel=>scont, 
                output=>mCont
            );

	cont: registerN 
			generic map(
                width=>width_n
                )
			port map(
                clock=>clock, 
                reset=>reset, 
                load=>ccont,
				input=>mCont,	
                output=>sContador
            );

	subtractor0: addersubtractor 
			generic map(
                N=>width_n, 
                isAdder=>false, 
                isSubtractor=>true, 
                generateOvf=>false 
                )
			port map(
                op=>'0', 
                a=>scontador, 
                b=>(0 => '1', others => '0'), 
                result=>contMenosUm, 
                ovf=>open, 
                cout => open
            );

	compare0: compare
			generic map (
                width=>width_n, 
                isSigned=>false, 
                generateLessThan=>false,
                generateEqual=>true 
                )
			port map (
                input0=>scontador, 
                input1=>(others => '0'), 
                lessThan=>open,
                equal=> zero
            );
			
	mux1: multiplexer2x1 
			generic map(
                width=>width_ent
                )
			port map(
                input0=>sSoma, 
                input1=>(others => '0'), 
                sel=>zAC, 
                output=>mAC
            );

	AC: registerN 
			generic map(
                width=>width_ent
                )
			port map(
                clock=>clock, 
                reset=>reset, 
                load=>cAC,
				input=>mAC,
                output=>sAc
            );
            
	T: registerN 
			generic map(
                width=>width_ent
                )
			port map(
                clock=>clock, 
                reset=>reset, 
                load=>cT,
				input=>ent,	
                output=>sT
            );

	adder0: addersubtractor 
			generic map(
                N=>width_ent, 
                isAdder=>true, 
                isSubtractor=>false,
                generateOvf=>false 
                )
			port map(
                op=>'0', 
                a=>sAc, 
                b=>sT, 
                result=>sSoma, 
                ovf=>open, 
                cout=>ov
            );

    soma <= sAc; 
        
end architecture;
