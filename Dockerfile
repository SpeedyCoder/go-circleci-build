FROM circleci/golang:1.11

USER root
WORKDIR /go/src/github.com/

ENV PROTOBUF_VERSION="3.6.1"

# Dowload given version of the protobuf binary
RUN wget https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d /usr/local && \
    rm protoc-${PROTOBUF_VERSION}-linux-x86_64.zip

# Clone golang/protobuf repo reset to the latest tag and install
RUN mkdir golang && cd golang && git clone https://github.com/golang/protobuf.git && \
    cd protobuf && git reset --hard $(git rev-list --tags --max-count=1) && \
    go install github.com/golang/protobuf/protoc-gen-go && \
    cd ../../ && rm -rf golang

# Clone gogo/protobuf repo reset to the latest tag and install
RUN mkdir gogo && cd gogo && git clone https://github.com/gogo/protobuf.git && \
    cd protobuf && git reset --hard $(git rev-list --tags --max-count=1) && \
    go install github.com/gogo/protobuf/protoc-gen-gogofast && \
    go install github.com/gogo/protobuf/protoc-gen-gogofaster && \
    go install github.com/gogo/protobuf/protoc-gen-gogoslick && \
    cd ../../ && rm -rf gogo

# Clone golangci repo reset to the latest tag and install
RUN mkdir golangci && cd golangci && git clone https://github.com/golangci/golangci-lint.git && \
    cd golangci-lint && git reset --hard $(git rev-list --tags --max-count=1) && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint && \
    cd ../../ && rm -rf golangci
