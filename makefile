prefix = /users/blink/.local/homebrew/Cellar/mingw-w64/9.0.0_2/toolchain-x86_64/bin

x86_path = ${prefix}/i686-w64-mingw32
x64_path = ${prefix}/x86_64-w64-mingw32
cc32 = $(x86_path)-gcc
cc64 = $(x64_path)-gcc
dlltool32 = $(x86_path)-dlltool
dlltool64 = $(x64_path)-dlltool
ino = ${GOPATH}/bin/ino

arches = 386 amd64
arch = $(word 1, $@)
out ?= evil.dll

opt.386.cc = ${cc32}
opt.386.dlltool = ${dlltool32}
opt.amd64.cc = ${cc64}
opt.amd64.dlltool = ${dlltool64}

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))

.PHONY: $(arches)
${arches}: $(ino)
	${ino} -def ${hijack} ${from} > fwd.def
	cat fwd.def
	${opt.${arch}.dlltool} --input-def fwd.def --output-exp fwd.exp
	GOOS=windows \
	GOARCH=${arch} \
	GO111MODULE=off \
	CGO_ENABLED=1 \
	CC=${opt.${arch}.cc} \
	go build -buildmode=c-shared -o ${out} -ldflags="-extldflags=-Wl,$(current_dir)fwd.exp" main.go

.PHONY: clean
clean:
	rm *.exp *.def *.exe *.dll

$(ino):
	go install github.com/audibleblink/ino@latest
