#!/Users/leibor/anaconda3/bin/python
import socket
import sys

print("ip   : " + sys.argv[1])
print("port : " + sys.argv[2])

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
result = sock.connect_ex((sys.argv[1],int(sys.argv[2])))

if result == 0:
   print("Port is open")
else:
   print("Port is not open")

sock.close()
