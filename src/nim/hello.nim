import jsbind/emscripten

proc handle() {.EMSCRIPTEN_KEEPALIVE.} =
  echo "Hello nim wasm"
