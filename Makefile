DOCKER_IMAGE = localhost:31000/amb-sidecar-plugin:$(shell git describe --tags --always --dirty)

# The Go version must exactly match what was used to compile the amb-sidecar
GO_VERSION = 1.11.4

ifeq ($(shell go version),go version go$(GO_VERSION) linux/amd64)
RUN =
else
RUN = docker run --rm -it --volume $(CURDIR):$(CURDIR):rw --workdir $(CURDIR) golang:$(GO_VERSION)
endif

all: .docker.stamp
.docker.stamp: example-plugin.so Dockerfile
	docker build -t $(DOCKER_IMAGE) .
	date > $@

example-plugin.so: FORCE
	$(RUN) env GOOS=linux GOARCH=amd64 go build -buildmode=plugin -o $@ .

clean:
	rm -f -- *.so .docker.stamp

.PHONY: FORCE all clean
.DELETE_ON_ERROR:
