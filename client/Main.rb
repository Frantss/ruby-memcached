require 'socket'


socket = TCPSocket.new('localhost', 5001)
socket.puts("get key\r\nget\r\n")
socket.puts("get\r\n")

