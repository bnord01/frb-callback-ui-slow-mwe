#!/bin/bash
set -ex

flutter_rust_bridge_codegen create app

cp main.dart app/lib/main.dart
cp simple.rs app/rust/src/api/simple.rs

cd app/rust
cargo add lazy_static