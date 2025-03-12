import socket
import numpy as np
import re       

def plc_receiver():
    localIP = "192.168.1.47" #41 IP PC
    localPort = 12050
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_address = (localIP, localPort)
    sock.bind(server_address)
    data, addr = sock.recvfrom(1024)  
    q_udp = data.decode('utf-8')
    q_string = str(q_udp)   
    print(q_string)
    
def main(args=None):
    while(1):
        plc_receiver()
    
if __name__ == "__main__":
    main()