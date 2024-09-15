APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=yevhen157
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux
TARGETARCH?=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/yevhen9999/kbot/cmd.appVersion=${VERSION}

linux: TARGETOS = linux
linux: TARGETARCH = amd64
linux: build

arm: TARGETOS = darwin
arm: TARGETARCH = arm64
arm: build

macos: TARGETOS = darwin
macos: TARGETARCH = amd64
macos: build

windows: TARGETOS = windows
windows: TARGETARCH = amd64
windows: build

image:
	docker build --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
