echo "===== compile"
# emcc hello.c -s WASM=1 -s "EXPORTED_FUNCTIONS=['_main']" -s "EXPORTED_RUNTIME_METHODS=['cwrap']" -o hello.js
emcc -O3 -g2 -s ASYNCIFY=1 -s WASM=1 -s MODULARIZE -s DETERMINISTIC=1 -s NODERAWFS=0 -s FORCE_FILESYSTEM=1 -s NO_EXIT_RUNTIME=1 -s "EXPORTED_FUNCTIONS=['_main','_malloc']" -s "EXPORTED_RUNTIME_METHODS=['cwrap']" -o hello.js hello.c
echo "===== compile wat"
wasm2wat hello.wasm -o hello.wat
echo "===== copy to cjs"
cp hello.js hello.cjs
echo "===== run cjs"
node hello.cjs
echo "===== run index.js"
node index.js
