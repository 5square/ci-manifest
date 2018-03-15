FROM ubuntu:16.04 as builder

RUN apt-get update && apt-get install -y git curl build-essential
RUN curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
RUN curl -O https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && \
    tar -xvf go1.9.1.linux-amd64.tar.gz && \
    mv go /usr/local

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"

RUN mkdir -p $GOPATH/src && \
    cd $GOPATH/src && \
    mkdir -p github.com/estesp && \
    cd github.com/estesp && \
    git clone https://github.com/estesp/manifest-tool && \
    cd manifest-tool && \
    make static

FROM docker:17.12.0-ce-git

COPY --from=builder /go/src/github.com/estesp/manifest-tool/manifest-tool /usr/bin/manifest-tool
