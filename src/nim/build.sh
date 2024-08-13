rm -fr tmp
nim c hello.nim
wasm2wat hello.wasm -o hello.wat
cp hello.js hello.cjs
node hello.cjs
