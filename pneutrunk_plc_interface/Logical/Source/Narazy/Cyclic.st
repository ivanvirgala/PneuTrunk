PROGRAM _CYCLIC
	
	FOR i:=0 TO 6 BY 1 DO
		IF modul.naraz[i] = TRUE THEN
			modul.narazAktivny	:= TRUE;
			step				:= 5;
		END_IF
	END_FOR
	 
END_PROGRAM
