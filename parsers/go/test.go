package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reqres := os.Args[1]
	// len, _ := strconv.Atoi(os.Args[2])

	reader := bufio.NewReader(os.Stdin)
	stdin, _ := reader.ReadString('\n')

	if reqres == "request" {
		fmt.Println(reqMarshal(reqParse(string(stdin))))
	} else if reqres == "response" {
		fmt.Println(resMarshal(resParse(stdin)))
	} else {
		println("invalid request response given")
	}
}
