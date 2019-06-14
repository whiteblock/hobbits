package main

import (
	"log"

	"github.com/sparrc/go-ping"
)

func pinger() {

	pinger, err := ping.NewPinger(ip)
	if err != nil {
		log.Fatalf("ERROR: %s\n", err.Error())
	}
	pinger.SetPrivileged(true)
	log.Println("Starting Ping Test....")

	pinger.OnRecv = func(pkt *ping.Packet) {
		pinger.Count = 5
		log.Printf("%d bytes from %s: icmp_seq=%d time=%v\n",
			pkt.Nbytes, pkt.IPAddr, pkt.Seq, pkt.Rtt)
	}
	log.Println("IP is valid. Pinging...")

	pinger.OnFinish = func(stats *ping.Statistics) {
		log.Printf("\n--- %s ping statistics ---\n", stats.Addr)
		log.Printf("%d packets transmitted, %d packets received, %v%% packet loss\n",
			stats.PacketsSent, stats.PacketsRecv, stats.PacketLoss)
		log.Printf("round-trip min/avg/max/stddev = %v/%v/%v/%v\n",
			stats.MinRtt, stats.AvgRtt, stats.MaxRtt, stats.StdDevRtt)

	}

	log.Printf("PING %s (%s):\n", pinger.Addr(), pinger.IPAddr())
	pinger.Run()

}
