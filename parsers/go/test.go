package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	reqres := os.Args[1]
	len, err := strconv.Atoi(os.Args[2])
	if err != nil {
		panic(err)
	}

	reader := bufio.NewReader(os.Stdin)
	buffer := make([]byte, len)
	reader.Read(buffer)
	if reqres == "request" {
		fmt.Printf(reqMarshal(reqParse(string(buffer))))
	} else {
		fmt.Println("invalid request given")
	}
}
