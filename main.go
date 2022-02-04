package main

import "C"

import (
	"unsafe"

	"golang.org/x/sys/windows"
)

//export Test
func Test() {
	windows.MessageBox(0, windows.StringToUTF16Ptr("hello from"), windows.StringToUTF16Ptr("Test"), 0)
}

//export OnProcessAttach
func OnProcessAttach(
	hinstDLL unsafe.Pointer, // handle to DLL module
	fdwReason uint32, // reason for calling function
	lpReserved unsafe.Pointer, // reserved
) {
	windows.MessageBox(0, windows.StringToUTF16Ptr("hello from"), windows.StringToUTF16Ptr("OPA"), 0)
}

func main() {}
