package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	file, err := os.Open("input")

	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	scanner := bufio.NewScanner(file)

	horizontal := 0
	depth := 0

	for scanner.Scan() {
		line := scanner.Text()
		re := regexp.MustCompile("\\s+")
		components := re.Split(line, 2)
		command := components[0]
		value, err := strconv.Atoi(components[1])
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		switch command {
		case "forward":
			horizontal += value
		case "up":
			depth -= value
		case "down":
			depth += value
		default:
			fmt.Fprintln(os.Stderr, "unsupported command"+command)
			os.Exit(1)
		}
	}
	fmt.Println(depth * horizontal)
}
