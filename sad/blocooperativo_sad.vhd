library ieee;
use ieee.std_logic_1164.all;

entity blocooperativo_sad is
	generic(
		datawidth: positive;
		addresswidth: positive);
	port(
		-- control in
		ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		menor: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
end entity;

architecture archstruct of blocooperativo_sad is

	component multiplexer2x1 is
		generic (	width: positive );
		port(	input0, input1: in std_logic_vector(width-1 downto 0) := (others => '0');
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
	
	component absN is
	generic(	width: positive );
	port(	input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0) );
	end component;
	
	signal isoma, ioutmux, ioutreg, izero: std_logic_vector(datawidth-2 downto 0);
	signal imaisum, iend, addresswidthum, addresswidthzeros: std_logic_vector(addresswidth-1 downto 0);
	signal icout: std_logic;	
	signal paoutreg, pboutreg, aboutsub, absoutsub: std_logic_vector(datawidth-1 downto 0);	
	signal absconcOut, somaoutreg, addrdatawidthzeros, absoutmux, aboutadd, sadoutreg: std_logic_vector(datawidth+addresswidth-1 downto 0);
	
begin
	addresswidthum(addresswidth-1 downto 0) <= (0=>'1', others=>'0');
	addresswidthzeros(addresswidth-1 downto 0) <= (others=>'0');
	addrdatawidthzeros(datawidth+addresswidth-1 downto 0) <= (others=>'0');
 	
	izero(datawidth-2 downto 0) <= (others=>'0');
	
	muxi: multiplexer2x1 
			generic map(width=>datawidth-1)
			port map(input0=>isoma, input1=>izero, sel=>zi, output=>ioutmux);
			
	i: registerN 
			generic map(width=>datawidth-1)
			port map(clock=>ck, reset=>reset, load=>ci, input=>ioutmux, output=>ioutreg);
				
	
	iend <= ioutreg(addresswidth-1 downto 0);
	ender <= iend;
	menor <= not ioutreg(datawidth-2);
				
	addi: addersubtractor 
			generic map(N=>addresswidth, isAdder=>true, isSubtractor=>false, generateOvf=>false)
			port map(op=>'0', a=>iend, b=>addresswidthum, result=>imaisum, ovf=>open, cout=>icout);
			
	isoma(addresswidth-1 downto 0) <=  imaisum;
	isoma(datawidth-2) <=  icout;
	
	A: registerN 
			generic map(width=>datawidth)
			port map(clock=>ck, reset=>reset, load=>cpA, input=>pA, output=>paoutreg);
				
	B: registerN 
			generic map(width=>datawidth)
			port map(clock=>ck, reset=>reset, load=>cpB, input=>pB, output=>pboutreg);
				
	subAB: addersubtractor 
			generic map(N=>datawidth, isAdder=>false, isSubtractor=>true, generateOvf=>false)
			port map(op=>'1', a=>paoutreg, b=>pboutreg, result=>aboutsub, ovf=>open, cout=>open);
			
	abssub: absN
			generic map	(width=>datawidth)
			port map(input=> aboutsub, output=> absoutsub);
			
	absconcOut(datawidth+addresswidth-1 downto datawidth) <= addresswidthzeros;
	absconcOut(datawidth-1 downto 0) <= absoutsub;
	
	addabs: addersubtractor 
			generic map(N=>datawidth+addresswidth, isAdder=>true, isSubtractor=>false, generateOvf=>false)
			port map(op=>'0', a=>somaoutreg, b=>absconcOut, result=>aboutadd, ovf=>open, cout=>open);
	
	muxabs: multiplexer2x1 
			generic map(width=>datawidth+addresswidth)
			port map(input0=>aboutadd, input1=>addrdatawidthzeros, sel=>zsoma, output=>absoutmux);
					
	soma: registerN 
			generic map(width=>datawidth+addresswidth)
			port map(clock=>ck, reset=>reset, load=>csoma, input=>absoutmux,	output=>somaoutreg);
	
	SADreg: registerN 
			generic map(width=>datawidth+addresswidth)
			port map(clock=>ck, reset=>reset, load=>csad_reg, input=>somaoutreg, output=>sadoutreg);
							
	sad <= sadoutreg;
end architecture;