#!/bin/bash -eu

apps="$PWD/apps"
bin_dir="$apps/bin"
mkdir -p "$bin_dir"

echo "==> Building Counter App"
pushd "$apps/counter" >& /dev/null

CGO_ENABLED=0 go build -a -installsuffix cgo -o "$bin_dir"

popd >& /dev/null

echo "==> Building Dashboard App"
pushd "$apps/dashboard" >& /dev/null

# rice embed-go
CGO_ENABLED=0 go build -a -installsuffix cgo -o "$bin_dir"

popd >& /dev/null


echo "==> Build Complete"
