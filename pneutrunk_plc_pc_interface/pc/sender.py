import socket
import numpy as np
import time       

message = ""
pressureBar = np.zeros(22)
pressures = np.zeros(22)

def plc_sender():
    UDP_IP = "192.168.1.45"             # IP address of PLC , bolo: 192.168.1.38
    UDP_PORT = 12050
    # equation: pressure*32767/9
    # 2bar: 
    # module 1
    pressureBar[0] = 0
    pressureBar[1] = 0
    pressureBar[2] = 0
    # module 2
    pressureBar[3] = 0
    pressureBar[4] = 0
    pressureBar[5] = 0
    # module 3
    pressureBar[6] = 0
    pressureBar[7] = 0
    pressureBar[8] = 0
    # module 4
    pressureBar[9] = 0
    pressureBar[10] = 0
    pressureBar[11] = 0
    # module 5
    pressureBar[12] = 0
    pressureBar[13] = 0
    pressureBar[14] = 0
    # module 6
    pressureBar[15] = 0
    pressureBar[16] = 0
    pressureBar[17] = 0
    # module 7
    pressureBar[18] = 0
    pressureBar[19] = 0
    pressureBar[20] = 0
    # module 8 - linear
    pressureBar[21] = 0

    # bar to 0->32767
    message = "pressures:"
    for i in range(len(pressureBar)):
        pressures[i] = int(pressureBar[i]*32767/9)
        message = message + str(pressures[i]) + ","
    message = message + ",end"
    #Final packet should be: message = "pressures:10000,10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019,10020,10021,end"
    message = str.encode(message)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(message, (UDP_IP, UDP_PORT))
    print(message)
    
def main(args=None):
    while(1):
        plc_sender()
        
        time.sleep(3)
    
if __name__ == "__main__":
    main()