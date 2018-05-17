FROM ubuntu:16.04 as builder

RUN apt-get update && apt-get install -y git curl build-essential
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

#--------------------------------------------------------------------------------
# Labelling
#--------------------------------------------------------------------------------

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
LABEL de.5square.build-date=$BUILD_DATE \
      de.5square.name="${BASE_IMAGE_NAMESPACE}${BASE_IMAGE}" \
      de.5square.description="Tool for creating Manifests for Multi-Arch builds" \
      de.5square.url="5square.de" \
      de.5square.vcs-ref=$VCS_REF \
      de.5square.vcs-url="$VCS_URL" \
      de.5square.vendor="5square" \
      de.5square.version=$VERSION \
      de.5square.schema-version="1.0"
