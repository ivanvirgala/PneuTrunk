(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: Client
 * File: Client.st
 * Author: Bernecker + Rainer
 * Created: June 02, 2008
 ********************************************************************
 * Implementation of program Client
 ********************************************************************)

PROGRAM _CYCLIC

	// 7/3/2025
	
	memset(ADR(LibAsUDP1_ST.send_data), 0, SIZEOF(LibAsUDP1_ST.send_data));
	memset(ADR(helpString), 0, SIZEOF(helpString));
	
	FOR i:=0 TO 6 BY 1 DO  
		ftoa(modul.alpha[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
		ftoa(modul.beta[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
	END_FOR
	
	//LibAsUDP1_ST.send_data[0] := LibAsUDP1_ST.send_data[0] + 1;  (* Generate a "running" variable for Data transfer *)
	//LibAsUDP1_ST.send_data := '20.12 12.54 10.24 -13.25';
	
	(*
	memset(ADR(LibAsUDP1_ST.send_data), 0, SIZEOF(LibAsUDP1_ST.send_data));
	memset(ADR(helpString), 0, SIZEOF(helpString));
	
	FOR i:=0 TO 6 BY 1 DO  
		ftoa(modul.uhol_XminusRef[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
		ftoa(modul.uhol_YminusRef[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
	END_FOR
	ftoa(modul.linearReal, ADR(helpString)); // vymenit za linearny 
	strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
	*)
	//strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
	

	(*
	memset(ADR(LibAsUDP1_ST.send_data), 0, SIZEOF(LibAsUDP1_ST.send_data));
	memset(ADR(helpString), 0, SIZEOF(helpString));
	
	FOR i:=0 TO 5 BY 1 DO  
		ftoa(modul.uhol1[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
		ftoa(modul.uhol2[i], ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
		strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
	END_FOR
	ftoa(modul.uhol2[0], ADR(helpString)); // vymenit za linearny 
	strcat(ADR(LibAsUDP1_ST.send_data), ADR(helpString));
	//strcat(ADR(LibAsUDP1_ST.send_data), ADR(','));
	*)
	CASE Client.sStep OF 
		
		0:	(* Open UDP Port *)
			Client.UdpOpen_0.enable := 1;
			Client.UdpOpen_0.pIfAddr := 0;	(* Listen on all TCP/IP Interfaces*)
			Client.UdpOpen_0.port := 12051;	(* Port to listen*)
			Client.UdpOpen_0.options := 0;
			Client.UdpOpen_0;	(* Call the Function*)
			
			IF Client.UdpOpen_0.status = 0 THEN  (* UdpOpen successful*)
				Client.sStep := 1;	
			ELSIF Client.UdpOpen_0.status = ERR_FUB_BUSY THEN  (* UdpOpen not finished -> redo *)			
			  (* Busy *)	
			ELSE  (* Goto Error Step *)
				Client.sStep := 10;
			END_IF
			
		1:	(* Send Data to the Server *)
			Client.server_address := '192.168.1.47';	(* IP Address of the Server *)
			Client.server_portnumber := 12050;	(* Port number of the Server *)
			
			Client.UdpSend_0.enable := 1;
			Client.UdpSend_0.ident := Client.UdpOpen_0.ident;	(* Connection Ident from AsUDP.UDP_Open *)
			Client.UdpSend_0.pHost := ADR(Client.server_address);	
			Client.UdpSend_0.port := Client.server_portnumber;		
			Client.UdpSend_0.pData := ADR(LibAsUDP1_ST.send_data);	(* Which data to send *)
			Client.UdpSend_0.datalen := SIZEOF(LibAsUDP1_ST.send_data);	(* Lenght of data to send *)
			Client.UdpSend_0.flags := 0;
			Client.UdpSend_0;	(* Call the Function*)
			
			IF Client.UdpSend_0.status = 0 THEN  (* Data sent *)
				Client.sStep := 2;					   
			ELSIF Client.UdpSend_0.status = ERR_FUB_BUSY THEN  (* UdpSend not finished -> redo *)						
			  (* Busy *)
			ELSE  (* Goto Error Step *)
				Client.sStep := 10;
			END_IF
			
		2:	(* Receive Data from the Server *)
			Client.UdpRecv_0.enable := 1;
			Client.UdpRecv_0.ident := Client.UdpOpen_0.ident;  (* Connection Ident from AsUDP.UDP_Open *)
			Client.UdpRecv_0.pData	:= ADR(LibAsUDP1_ST.receive_data);  (* Where to store the incoming data *)//ADR(LibAsUDP1_ST.receive_data);
			Client.UdpRecv_0.datamax := SIZEOF(LibAsUDP1_ST.receive_data);  (* Lenght of data buffer *)
			Client.UdpRecv_0.flags := 0;
			Client.UdpRecv_0;  (* Call the Function*)
		
			IF Client.UdpRecv_0.status = 0 THEN  (* Data was received successfully -> Send next packet *)
				Client.sStep := 3;
				Client.no_data_received_count := 0;
			ELSIF Client.UdpRecv_0.status = udpERR_NO_DATA THEN  (* No data received - wait *)
			  (* No Data received *)
			  	Client.no_data_received_count := Client.no_data_received_count + 1;	(* Increase if no data are received *)
				
				IF Client.no_data_received_count > 200 THEN		(* No data timeout for TC1 [10ms] *)
					Client.no_data_received_count := 0;
					Client.sStep := 1;	(* Send again *)
				END_IF				  
			ELSIF Client.UdpRecv_0.status = ERR_FUB_BUSY THEN  (* UdpRecv not finished -> redo *)		
			  (* Busy *)
			ELSE  (* Goto Error Step *)
				Client.sStep := 10;
			END_IF
			
		3: (* Close connection *)
			Client.UdpClose_0.enable := 1;
			Client.UdpClose_0.ident := Client.UdpOpen_0.ident;  (* Connection Ident from AsUDP.UDP_Open *)
			Client.UdpClose_0;  (* Call the Function*)
	
			IF Client.UdpClose_0.status = 0 THEN  (* Close successful -> Reopen the interface *)
				Client.sStep := 0;
			ELSIF Client.UdpClose_0.status = ERR_FUB_BUSY THEN  (* UdpClose not finished -> redo *)	
			  (* Busy *)
			ELSE  (* Goto Error Step *)
				Client.sStep := 10;
			END_IF
		
		10: (* Here some error Handling has to be implemented *)
		
	END_CASE

END_PROGRAM
