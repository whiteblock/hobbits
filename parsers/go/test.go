package main

import (
	"strconv"
	"bufio"
	"fmt"
	"os"
)

func main() {
	reqres := os.Args[1]
	len,err := strconv.Atoi(os.Args[2])
	if err != nil{
		panic(err)
	}

	reader := bufio.NewReader(os.Stdin)
	buffer := make([]byte,len)
	reader.Read(buffer)
	if reqres == "request" {
		fmt.Printf(reqMarshal(reqParse(string(buffer))))
	} else if reqres == "response" {
		fmt.Printf(resMarshal(resParse(string(buffer))))
	} else {
		fmt.Println("invalid request response given")
	}
}
