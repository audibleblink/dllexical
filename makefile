prefix = 
x86_path = ${prefix}i686-w64-mingw32
opt.386.cc = $(x86_path)-gcc
opt.386.dlltool = $(x86_path)-dlltool
x64_path = ${prefix}x86_64-w64-mingw32
opt.amd64.cc = $(x64_path)-gcc
opt.amd64.dlltool = $(x64_path)-dlltool
ino = ${GOPATH}/bin/ino

arches = 386 amd64
arch = $(word 1, $@)
dir ?= build
out ?= evil.dll


help: ## Usage: make amd64|386|all hijack=dbghelp.dll from=path/to/teams.exe
	@grep -E '^[a-zA-Z0-9]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: amd64 386 ## build x86 and x64 dll. required args: hijack= from=


${arches}: $(ino)
	@mkdir -p ${dir}
	${ino} -def ${hijack} ${from} > ${dir}/fwd.def
	@cat ${dir}/fwd.def
	${opt.${arch}.dlltool} --input-def ${dir}/fwd.def --output-exp ${dir}/fwd.exp
	GOOS=windows \
	GOARCH=${arch} \
	GO111MODULE=off \
	CGO_ENABLED=1 \
	CC=${opt.${arch}.cc} \
		go build -buildmode=c-shared \
		-ldflags="-extldflags=-Wl,$(PWD)/${dir}/fwd.exp" \
		-o ${dir}/${arch}_${out} main.go
amd64: ## build a 64-bit dll. required args: hijack= from=
386: ## build a 32-bit dll. required args: hijack= from=

clean: ## delete all generated files
	rm ${dir}/*

$(ino):
	go install github.com/audibleblink/ino@latest

.PHONY: all help clean $(arches)
