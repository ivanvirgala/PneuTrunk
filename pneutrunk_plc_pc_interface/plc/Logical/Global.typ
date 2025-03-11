
TYPE
	tlacidla : 	STRUCT 
		start : BOOL;
		ros : BOOL;
		stopLED : BOOL;
		stop : BOOL;
		startLED : BOOL;
		startButton : BOOL;
		centralStop : BOOL;
		stropBielaLED : BOOL;
		stropCervenaLED : BOOL;
		klucik : BOOL;
	END_STRUCT;
	automatic : 	STRUCT 
		y_desired : ARRAY[0..6]OF REAL := [7(0.0)];
		x_desired : ARRAY[0..6]OF REAL := [7(0.0)];
		linear : INT;
		ball_up : BOOL;
		casovac : BOOL;
		effector : BOOL;
		casovac_uchopenie : BOOL;
		ball_piston : BOOL;
		novyCyklus : TIME := T#1s;
		novyCyklusStart : BOOL;
		trajectoryStart2 : BOOL;
		trajectoryTime2 : TIME := T#6s;
		automatic : BOOL;
		holdPosition : BOOL;
		cas : INT;
		box : INT;
		step_color : INT;
		popcorn : BOOL;
		testFarba : INT;
		loptickyVzasobniku : BOOL := TRUE;
		x_desired_previous : ARRAY[0..6]OF INT;
		y_desired_previous : ARRAY[0..6]OF INT;
		I_konstanta : ARRAY[0..6]OF INT;
		levitacia : BOOL;
		desiredPressure2 : ARRAY[0..6]OF INT;
		desiredPressure3 : ARRAY[0..6]OF INT;
		desiredPressure3_previous : ARRAY[0..6]OF INT;
		desiredPressure2_previous : ARRAY[0..6]OF INT;
		desiredPressure1_previous : ARRAY[0..6]OF INT;
		desiredPressureLinear : INT;
		desiredPressure1 : ARRAY[0..6]OF INT;
		step_repeatability : INT;
		handControl : BOOL;
		experiment2 : BOOL;
		experiment3 : BOOL;
		experiment1 : BOOL;
	END_STRUCT;
	packetRS485 : 	STRUCT 
		packet : ARRAY[0..9]OF BYTE;
		sendPacketLED : ARRAY[0..5]OF BYTE;
		sendPacketSnimace : ARRAY[0..5]OF BYTE;
		sendPacketFinal : ARRAY[0..5]OF BYTE;
		id : USINT;
	END_STRUCT;
	packetUDP : 	STRUCT 
		qLength : INT;
		c : INT;
		q : INT;
		qFull : STRING[80];
		comma : INT;
		qString : ARRAY[0..14]OF STRING[6];
		qDesired : ARRAY[0..14]OF REAL;
		color : INT;
		step : INT;
	END_STRUCT;
	tlaky : 	STRUCT 
		tlak3 : USINT;
		tlak2 : USINT;
		tlak1 : USINT;
	END_STRUCT;
	moduly : 	STRUCT 
		uhol2 : ARRAY[0..6]OF REAL := [7(0.0)];
		uhol1 : ARRAY[0..6]OF REAL := [7(0.0)];
		koncak : ARRAY[0..6]OF BOOL;
		led : ARRAY[0..6]OF BOOL;
		uholINT2 : INT;
		uholINT1 : INT;
		tlak1 : ARRAY[0..6]OF INT;
		tlak2 : ARRAY[0..6]OF INT;
		tlak3 : ARRAY[0..6]OF INT;
		tlakLinear : INT;
		alpha : ARRAY[0..6]OF REAL; (*uhol ktory posiela PLC do PC po odpocitani odchylky naklonenia realneho robota*)
		beta : ARRAY[0..6]OF REAL; (*uhol ktory posiela PLC do PC po odpocitani odchylky naklonenia realneho robota*)
		linearReal : REAL;
		naraz : ARRAY[0..7]OF BOOL;
		narazAktivny : BOOL;
	END_STRUCT;
END_TYPE
