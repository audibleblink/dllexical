# dllivery

Create a golang dll with forwards to another PE's imports

## Usage

To proxy all functions from `version.dll` that `teams.exe` imports:

```go
package main

import "C"

func init() {
	go func() {
    // your code here
	}()
}

func main() { /* still necessary for go dlls  */ }
```

```zsh
make amd64 hijack=version.dll from=teams.exe
make  386  hijack=version.dll from=teams.exe
```
