#!/usr/bin/env bash
cp ../prefab-cloud/prefab.proto .
protoc --elixir_out=plugins=grpc:./lib/ prefab.proto
