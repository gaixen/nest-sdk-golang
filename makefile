BINARY = nest-sdk-golang
VET_REPORT = vet.report
TEST_REPORT = tests.xml
GOARCH ?= amd64

VERSION ?= $(shell git describe --tags --always --dirty)
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)

# linker flags to embed build information
LDFLAGS = -ldflags "-X main.VERSION=${VERSION} -X main.COMMIT=${COMMIT} -X main.BRANCH=${BRANCH}"

all: clean vet test build

# build binary for current OS
build:
	go build ${LDFLAGS} -o ${BINARY}

# cross-compile targets
linux:
	GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-linux-${GOARCH}

darwin:
	GOOS=darwin GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-darwin-${GOARCH}

windows:
	GOOS=windows GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BINARY}-windows-${GOARCH}.exe

# run unit tests
test:
	go test ./... -v

# run go vet and save report
vet:
	-go vet ./... 2> ${VET_REPORT} || true

# format packages
fmt:
	go fmt ./...

clean:
	-rm -f ${TEST_REPORT} ${VET_REPORT} ${BINARY} ${BINARY}-*

.PHONY: all build linux darwin windows test vet fmt clean
Ask
