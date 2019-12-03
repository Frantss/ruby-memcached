require 'socket'


server = TCPSocket.new('localhost', 5001)

listener = Thread.new {
    while response = server.gets()
        puts("Server: " + response)
    end
}

speaker = Thread.new {
    while true
        print("> ")
        server.puts(gets())
        sleep(0.1)
    end
}

listener.join()
speaker.join()

server.close()