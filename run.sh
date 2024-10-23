#!/bin/bash
set -e

cd app

flutter_rust_bridge_codegen generate
flutter_rust_bridge_codegen build-web --release

flutter run \
    -d chrome \
    --release \
    --web-header=Cross-Origin-Opener-Policy=same-origin \
    --web-header=Cross-Origin-Embedder-Policy=require-corp
