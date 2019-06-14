package main

import (
	"log"
	"net"
)

func porter() {
	ln, err := net.Dial("tcp", ip+":"+port)

	if err != nil {
		log.Fatalf("Test failed. Port %q: %s unavailable.", port, err)
	}

	err = ln.Close()
	if err != nil {
		log.Fatalf("Couldn't close port %q: %s", port, err)
	}

	log.Printf("TCP Port %q is available", port)
}
