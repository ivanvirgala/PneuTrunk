(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: Server
 * File: Server.typ
 * Author: Bernecker + Rainer
 * Created: June 02, 2008
 ********************************************************************
 * Local data types of program Server
 ********************************************************************)

TYPE
	Server_typ : 	STRUCT  (*UDP Server Variables*)
		sStep : UINT; (*UDP Server Step Variable*)
		client_address : STRING[20]; (*Address of the client connection to the Server*)
		UdpOpen_0 : UdpOpen; (*AsUDP.UdpOpen FUB*)
		UdpConnect_0 : UdpConnect; (*AsUDP.UdpConnect FUB*)
		UdpSend_0 : UdpSend; (*AsUDP.UdpSend FUB*)
		UdpRecv_0 : UdpRecv; (*AsUDP.UdpRecv FUB*)
		UdpDisconnect_0 : UdpDisconnect; (*AsUDP.UdpDisconnect FUB*)
		UdpClose_0 : UdpClose; (*AsUDP.UdpClose FUB*)
		data_buffer : STRING[256]; (*Data buffer ( receive and send )*)
	END_STRUCT;
END_TYPE
