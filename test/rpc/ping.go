package main

import (
	"fmt"

	"github.com/sparrc/go-ping"
)

func pinger() {

	pinger, err := ping.NewPinger(ip)
	if err != nil {
		fmt.Printf("ERROR: %s\n", err.Error())
		return
	}
	fmt.Println("Starting Ping Test....")

	pinger.OnRecv = func(pkt *ping.Packet) {
		pinger.Count = 5
		fmt.Printf("%d bytes from %s: icmp_seq=%d time=%v\n",
			pkt.Nbytes, pkt.IPAddr, pkt.Seq, pkt.Rtt)
	}
	fmt.Println("IP is valid. Pinging...")

	pinger.OnFinish = func(stats *ping.Statistics) {
		fmt.Printf("\n--- %s ping statistics ---\n", stats.Addr)
		fmt.Printf("%d packets transmitted, %d packets received, %v%% packet loss\n",
			stats.PacketsSent, stats.PacketsRecv, stats.PacketLoss)
		fmt.Printf("round-trip min/avg/max/stddev = %v/%v/%v/%v\n",
			stats.MinRtt, stats.AvgRtt, stats.MaxRtt, stats.StdDevRtt)

	}

	fmt.Printf("PING %s (%s):\n", pinger.Addr(), pinger.IPAddr())
	pinger.Run()

}
