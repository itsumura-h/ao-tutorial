Nim WASM

[jsbind](https://github.com/yglukhov/jsbind)

[nim_emscripten_tutorial](https://github.com/treeform/nim_emscripten_tutorial)


---

[AO JS loader](https://github.com/permaweb/ao/tree/main/loader)

[ao-build-module](https://github.com/permaweb/ao/blob/main/dev-cli/container/src/ao-build-module)

```
emcc -O3 -g2 -s ASYNCIFY=1 -s MEMORY64=1 -s STACK_SIZE=... -s ASYNCIFY_STACK_SIZE=... -s ALLOW_MEMORY_GROWTH=1 \
-s INITIAL_MEMORY=... -s MAXIMUM_MEMORY=... -s WASM=1 -s MODULARIZE -s DETERMINISTIC=1 -s NODERAWFS=0 -s FORCE_FILESYSTEM=1 \
-msimd128 --pre-js /opt/pre.js -L/opt/aolibc -l:aolibc.a -s ASSERTIONS=1 -I /lua-{LUA_VERSION}/src -s EXPORTED_FUNCTIONS=["_malloc", "_main"] \
-s EXPORTED_RUNTIME_METHODS=["cwrap"] -lm -ldl -o <output_file> <additional_source_files> <additional_libraries> <extra_args>
```

AOで動かすには
- wasm32-unknown-emscriptenでコンパイルする
