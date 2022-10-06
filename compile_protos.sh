#!/usr/bin/env bash
# follow instructions here to ensure protoc-gen-elixir is installed
# https://github.com/elixir-protobuf/protobuf#usage
cp ../prefab-cloud/prefab.proto .
protoc --elixir_out=plugins=grpc:./lib/ prefab.proto
