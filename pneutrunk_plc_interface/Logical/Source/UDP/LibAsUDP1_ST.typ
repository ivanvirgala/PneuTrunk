(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * File: Global.typ
 * Author: Bernecker + Rainer
 * Created: June 02, 2008
 ********************************************************************
 * Global data types of project LibAsUDP
 ********************************************************************)

TYPE
	LibAsUDP1_ST_typ : 	STRUCT  (*Datatyp for global Variables*)
		receive_data : ARRAY[0..100]OF UDINT; (*Data which has been received*)
		send_data : STRING[80]; (*Data which should be sent*)
	END_STRUCT;
END_TYPE
