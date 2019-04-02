package main

import (
	"fmt"

	ping "github.com/sparrc/go-ping"
	"github.com/spf13/pflag"
)

var (
	ip   string
	port int
)

// checks to see if ip address is available and responsive

func main() {
	pflag.StringVarP(&ip, "ip", "i", "10.1.0.2", "ip address")
	pflag.IntVarP(&port, "port", "p", 9000, "port")

	pflag.Parse()

	pinger, err := ping.NewPinger(ip)
	if err != nil {
		fmt.Printf("ERROR: %s\n", err.Error())
		return
	}

	pinger.OnRecv = func(pkt *ping.Packet) {
		pinger.Count = 5
		fmt.Printf("%d bytes from %s: icmp_seq=%d time=%v\n",
			pkt.Nbytes, pkt.IPAddr, pkt.Seq, pkt.Rtt)
	}
	pinger.OnFinish = func(stats *ping.Statistics) {
		fmt.Printf("\n--- %s ping statistics ---\n", stats.Addr)
		fmt.Printf("%d packets transmitted, %d packets received, %v%% packet loss\n",
			stats.PacketsSent, stats.PacketsRecv, stats.PacketLoss)
		fmt.Printf("round-trip min/avg/max/stddev = %v/%v/%v/%v\n",
			stats.MinRtt, stats.AvgRtt, stats.MaxRtt, stats.StdDevRtt)
		fmt.Printf("IP is Available & Responsive!\n")
	}

	// TODO
	// Test Ports
	// Once ip address has been determined to be available, need to
	// use net library to try and establish a connection to the given port
	// if connection cannot be made, test fails.
	//
	// Test Messages
	// If port is available, send message, await response on timeout.
	// If response is not received, test fails.
	// If response is received, then move on to validate message format.

}
