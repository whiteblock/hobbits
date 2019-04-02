package main

import (
	"fmt"
	"net"
	"os"
)

func porter() {
	ln, err := net.Listen("tcp", ip+":"+port)

	if err != nil {
		fmt.Fprintf(os.Stderr, "Test failed. Port %q: %s unavailable.", port, err)
		os.Exit(1)
	}

	err = ln.Close()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Couldn't close port %q: %s", port, err)
		os.Exit(1)
	}

	fmt.Printf("TCP Port %q is available", port)
	os.Exit(0)
}
