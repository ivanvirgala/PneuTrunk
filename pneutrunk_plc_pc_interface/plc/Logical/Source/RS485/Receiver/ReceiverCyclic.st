(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: Receiver
 * File: ReceiverCyclic.st
 * Author: Bernecker & Rainer
 * Created: January 25, 2010
 ********************************************************************
 * Implementation of program Receiver
 ********************************************************************)

(*************init program**********************)
PROGRAM _INIT
	Receiver.Commands.open_receive := TRUE;												(*enable Receiver by default*)						
END_PROGRAM

(*************cyclic program********************)
PROGRAM _CYCLIC


	CASE Receiver.step OF
		FRM_WAIT:	(*--- wait for command*)
			
			IF Receiver.Commands.open_receive = TRUE THEN								(*command for Receiver activation*)
				Receiver.step := FRM_OPEN;
   			END_IF			
		
			(*close will be requested in step FRM_RBUF*)
		
		FRM_OPEN:	(*--- open serial interface*)
			
			(*Parameters for FRM_xopen()*)
			Receiver.FRM_xopen_0.enable := TRUE;
			Receiver.FRM_xopen_0.device := ADR('IF6.ST1.IF1');							(*Devicename --> see your serial interface properties*)
			Receiver.FRM_xopen_0.mode := ADR('/PHY=RS485 /BD=38400 /DB=8 /PA=N /SB=1'); (*Modestring --> specifies the seria operation mode*)
			Receiver.FRM_xopen_0.config := ADR(Receiver.xopenConfig) ;					(*Additional Parameters, optional*)
			
			(*Additional Parameters for FRM_xopen()*)
			Receiver.xopenConfig.idle := 10;											(*Idle time between two characters*)
			Receiver.xopenConfig.delimc := 0;											(*activate two delimeters*)
			Receiver.xopenConfig.delim[0] := 0; 										(*e.g. CR - carridge return -> dec 13*)
			Receiver.xopenConfig.delim[1] := 0; 										(*e.g. LF - line feed -> dec 10*)
			Receiver.xopenConfig.tx_cnt := 3;											(*number of transmit buffers*)
			Receiver.xopenConfig.rx_cnt := 3; 											(*number of receive buffers*)
			Receiver.xopenConfig.tx_len := 256; 										(*length of transmit buffers*)
			Receiver.xopenConfig.rx_len := 256; 										(*lenght of receive buffers*)
			Receiver.xopenConfig.argc := 0;												(*activate additional options*)
			Receiver.xopenConfig.argv := 0;												(*parameters for additional options (check help)*)
		
			Receiver.FRM_xopen_0();														(*call the FRM_xopen() function*)
			
			IF Receiver.FRM_xopen_0.status = 0 THEN
				Receiver.step := FRM_READ;												(*Interface opend successfully --> next step*)
			ELSIF Receiver.FRM_xopen_0.status = BUSY THEN
				Receiver.step := FRM_OPEN;												(*operation not finished yet --> call again*)
			ELSE
				Receiver.step := FRM_ERROR;												(*function returned errorcode --> check help*)
   			END_IF			
			
		FRM_READ:	(*--- read data from serial interface*)
			Receiver.FRM_read_0.enable := TRUE;
   			Receiver.FRM_read_0.ident := Receiver.FRM_xopen_0.ident;
			
			Receiver.FRM_read_0();														(*call the FRM_read() function*)
			
			IF Receiver.FRM_read_0.status = 0 THEN
				Receiver.step := FRM_COPY_RD_DATA;										(*system returned a valid data --> next step*)
			ELSIF Receiver.FRM_read_0.status = frmERR_NOINPUT THEN
				Receiver.step := FRM_READ;												(*no data available --> call again*)
			ELSIF Receiver.FRM_read_0.status = frmERR_INPUTERROR THEN
				Receiver.step := FRM_RBUF;												(*received Frame with defective characters, skip data*)
			ELSE
				Receiver.step := FRM_ERROR;												(*function returned errorcode --> check help*)
   			END_IF			
			
		
		FRM_COPY_RD_DATA: (*--- copy data out of the receive buffer*)
			(*
			FOR i:=0 TO 8 BY 1 DO
				packet485.packet[i] := Receiver.receive_data[i];
			END_FOR
			*)
			memset(ADR(Receiver.receive_data),0,SIZEOF(Receiver.receive_data));			(*clear read_data buffer*)
			memcpy(ADR(Receiver.receive_data),Receiver.FRM_read_0.buffer,Receiver.FRM_read_0.buflng);     (*copy and evaluate read data*)

			
			IF(Receiver.receive_data[0] = 255)THEN
				IF(Receiver.receive_data[1] = 255)THEN
					IF(Receiver.receive_data[9] = 254)THEN
						IF(Receiver.receive_data[10] = 254)THEN
							IF(Receiver.receive_data[2] = 1)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[0] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[0] := modul.uhol1[0]*260/1024 - 130;
								modul.uhol1[0] := modul.uhol1[0]*1.0233 + 88.745;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[0] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[0] := modul.uhol2[0]*260/1024 - 130;
								modul.uhol2[0] := modul.uhol2[0]*1.0275 + 89.292;
							ELSIF(Receiver.receive_data[2] = 2)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[1] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[1] := modul.uhol1[1]*260/1024 - 130;
								modul.uhol1[1] := modul.uhol1[1]*1.0228 + 88.871;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[1] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[1] := modul.uhol2[1]*260/1024 - 130;
								modul.uhol2[1] := modul.uhol2[1]*1.0079 + 89.873;
							ELSIF(Receiver.receive_data[2] = 3)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[2] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[2] := modul.uhol1[2]*260/1024 - 130;
								modul.uhol1[2] := modul.uhol1[2]*1.0235 + 90.761;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[2] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[2] := modul.uhol2[2]*260/1024 - 130;
								modul.uhol2[2] := modul.uhol2[2]*1.043 + 92.476;
								IF Receiver.receive_data[4] = 3 OR Receiver.receive_data[4] > 15 THEN
									modul.naraz[2]	:= TRUE;
								ELSE
									modul.naraz[2]	:= FALSE;
								END_IF
							ELSIF(Receiver.receive_data[2] = 4)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[3] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[3] := modul.uhol1[3]*260/1024 - 130;
								modul.uhol1[3] := modul.uhol1[3]*1.0254 + 88.307;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[3] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[3] := modul.uhol2[3]*260/1024 - 130;
								modul.uhol2[3] := modul.uhol2[3]*1.0308 + 90.739;
								IF Receiver.receive_data[4] = 3 OR Receiver.receive_data[4] > 15 THEN
									modul.naraz[3]	:= TRUE;
								ELSE
									modul.naraz[3]	:= FALSE;
								END_IF
							ELSIF(Receiver.receive_data[2] = 5)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[4] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[4] := modul.uhol1[4]*260/1024 - 130;
								modul.uhol1[4] := modul.uhol1[4]*1.0216 + 90.3;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[4] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[4] := modul.uhol2[4]*260/1024 - 130;
								modul.uhol2[4] := modul.uhol2[4]*1.008 + 86.877;
								IF Receiver.receive_data[4] = 3 OR Receiver.receive_data[4] > 15  THEN
									modul.naraz[4]	:= TRUE;
								ELSE
									modul.naraz[4]	:= FALSE;
								END_IF
							ELSIF(Receiver.receive_data[2] = 6)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[5] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[5] := modul.uhol1[5]*260/1024 - 130;
								modul.uhol1[5] := modul.uhol1[5]*1.0039 + 87.274;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[5] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[5] := modul.uhol2[5]*260/1024 - 130;
								modul.uhol2[5] := modul.uhol2[5]*1.0009 + 87.856;
								IF Receiver.receive_data[4] = 3 OR Receiver.receive_data[4] > 15 THEN
									modul.naraz[5]	:= TRUE;
								ELSE
									modul.naraz[5]	:= FALSE;
								END_IF
							ELSIF(Receiver.receive_data[2] = 7)THEN
								modul.uholINT1 := BYTE_TO_INT(Receiver.receive_data[5]);
								modul.uholINT1 := SHL(modul.uholINT1,8);
								modul.uholINT1  := modul.uholINT1  + BYTE_TO_INT(Receiver.receive_data[6]);
								modul.uhol1[6] := INT_TO_REAL(modul.uholINT1);
								modul.uhol1[6] := modul.uhol1[6]*260/1024 - 130;
								modul.uhol1[6] := modul.uhol1[6]*1.0065 + 87.623;
								modul.uholINT2 := BYTE_TO_INT(Receiver.receive_data[7]);
								modul.uholINT2 := SHL(modul.uholINT2,8);
								modul.uholINT2  := modul.uholINT2  + BYTE_TO_INT(Receiver.receive_data[8]);
								modul.uhol2[6] := INT_TO_REAL(modul.uholINT2);
								modul.uhol2[6] := modul.uhol2[6]*260/1024 - 130;
								modul.uhol2[6] := modul.uhol2[6]*1.0258 + 90.567;
								IF Receiver.receive_data[4] = 1 OR Receiver.receive_data[4] = 2 OR Receiver.receive_data[4] > 15  THEN //lebo dve moduly su zapojene do jednej dosky
									modul.naraz[6]	:= TRUE;
								ELSE
									modul.naraz[6]	:= FALSE;
								END_IF
							ELSIF(Receiver.receive_data[2] = 8)THEN
								IF Receiver.receive_data[4] = 3 OR Receiver.receive_data[4] > 15 THEN
									modul.naraz[7]	:= TRUE;
								ELSE
									modul.naraz[7]	:= FALSE;
								END_IF
							END_IF
						END_IF
					END_IF
				END_IF
			END_IF
			
			
			Receiver.step := FRM_RBUF;													(*release read buffer*)
		
		FRM_RBUF:	(*--- release readbuffer*)
		
			(*Parameters for FRM_rbuf()*)
			Receiver.FRM_rbuf_0.enable := TRUE;
			Receiver.FRM_rbuf_0.ident := Receiver.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)
			Receiver.FRM_rbuf_0.buffer := Receiver.FRM_read_0.buffer;					(*read buffer*)
			Receiver.FRM_rbuf_0.buflng := Receiver.FRM_read_0.buflng;					(*length of sendbuffer*)
   			
			Receiver.FRM_rbuf_0();														(*call the FRM_rbuf() function*)
			
			IF Receiver.FRM_rbuf_0.status = 0 THEN
				IF Receiver.Commands.close = TRUE THEN
					Receiver.Commands.open_receive := FALSE;								(*disable command open_send*)
					Receiver.step := FRM_CLOSE;											(*request to close serial port*)
				ELSE				
					Receiver.step := FRM_READ;											(*read again*)
				END_IF
			ELSIF Receiver.FRM_rbuf_0.status = BUSY THEN
				Receiver.step := FRM_RBUF;												(*operation not finished yet --> call again*)
			ELSIF Receiver.FRM_rbuf_0.status = frmERR_INVALIDBUFFER THEN					
				Receiver.step := FRM_READ;												(*buffer is invalid --> read again*)
			ELSE
				Receiver.step := FRM_ERROR;												(*function returned errorcode --> check help*)
   			END_IF			
		
		FRM_CLOSE:	(*--- close the interface*)
			Receiver.FRM_close_0.enable := TRUE;
   			Receiver.FRM_close_0.ident := Receiver.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)			
			
			Receiver.FRM_close_0();														(*call the FRM_close() function*)
			
			IF Receiver.FRM_close_0.status = 0 THEN
				Receiver.Commands.close := FALSE;										(*disable close command*)
				Receiver.step := FRM_WAIT;												(*closed interface successfully --> wait step*)
			ELSIF Receiver.FRM_close_0.status = BUSY THEN
				Receiver.step := FRM_CLOSE;												(*operation not finished yet --> call again*)
			ELSE
				Receiver.step := FRM_ERROR;												(*function returned errorcode --> check help*)
			END_IF
			
		FRM_ERROR:	(*--- error handling*)
			; (*not implementet yet, check help for error codes*)
 	END_CASE	


END_PROGRAM
