package main

import (
	"fmt"

	"github.com/spf13/pflag"
)

var (
	ip   string
	port string
)

func main() {
	pflag.StringVarP(&ip, "ip", "i", "10.1.0.2", "ip address")
	pflag.StringVarP(&port, "port", "p", "9000", "port")

	pflag.Parse()

	pinger()
	fmt.Println("Ping test passed. Testing port...")
	porter()
	fmt.Printf("Port test passed. Testing message delivery...")

}
