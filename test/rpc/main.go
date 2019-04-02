package main

import (
	"github.com/spf13/pflag"
)

var (
	ip   string
	port int
)

func main() {
	pflag.StringVarP(&ip, "ip", "i", "10.1.0.2", "ip address")
	pflag.IntVarP(&port, "port", "p", 9000, "port")

	pflag.Parse()

	pinger()

}
