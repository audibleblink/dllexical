package main

import "C"
import "os"

func init() {
	go func() {
		os.WriteFile("testfile", []byte("d34dc0de"), 777)
	}()
}

func main() {}
