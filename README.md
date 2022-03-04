# dllexical

Create a golang dll that forwards a target PE's imports.
Uses [ino](github.com/audiblelink/ino) to generate \*.def files.
`dlltool` from mingw converts them to \*.exp files and it all gets passed
to the linker via go build's ldflags.

```zsh
go build -buildmode=c-shared -o ${out} -ldflags="-extldflags=-Wl,${pwd}/fwd.exp"
```

## Usage

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

To proxy all functions from `version.dll` that `teams.exe` imports:

```zsh
make amd64 hijack=version.dll from=path/to/teams.exe
make  386  hijack=version.dll from=path/to/teams.exe
```
