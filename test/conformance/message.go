package main

import (
	"fmt"
	"log"
	"net"
)

func messager() {
	conn, err := net.Dial("tcp", ip+":"+port)
	if err != nil {
		log.Fatalf("Error dialing %s:%s, %v\n", ip, port, err)
	}
	fmt.Fprintf(conn, "EWP 0.2 RPC 5 5\nhellohello")
	err = conn.Close()
	if err != nil {
		log.Fatalf("Error closing %s:%s, %v\n", ip, port, err)
	}
}
