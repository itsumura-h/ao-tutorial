--define: emscripten
# --define: node
--define: useMalloc
--define: release
--os:linux # Emscripten pretends to be linux.
--cpu:wasm32 # Emscripten is 32bits.
--cc:clang # Emscripten is very close to clang, so we ill replace it.
--nimcache:nimcache
when defined(windows):
  --clang.exe:emcc.bat  # Replace C
  --clang.linkerexe:emcc.bat # Replace C linker
  --clang.cpp.exe:emcc.bat # Replace C++s
  --clang.cpp.linkerexe:emcc.bat # Replace C++ linker.
else:
  --clang.exe:emcc  # Replace C
  --clang.linkerexe:emcc # Replace C linker
  --clang.cpp.exe:emcc # Replace C++
  --clang.cpp.linkerexe:emcc # Replace C++ linker.
--listCmd # List what commands we are running so that we can debug them.

--gc:arc # GC:arc is friendlier with crazy platforms.
--exceptions:goto # Goto exceptions are friendlier with crazy platforms.
--define:noSignalHandler # Emscripten doesn't support signal handlers.
--threads:off # 1.7.1 defaults this on
# --noMain:on
# let outputName = projectName() & ".wasm"
let outputName = "hello" & ".js"
# let outputName = "hello" & ".cjs"
# let outputName = "hello" & ".wasm"
# No need for main, it's standalone wasm, and we dont need to error on undefined as we're probably importing
switch("passC", "-O3 -g2 -s ASYNCIFY=1 -s WASM=1 -s MODULARIZE -s DETERMINISTIC=1 -s NODERAWFS=0 -s FORCE_FILESYSTEM=1 -s NO_EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='_malloc','_main' -s EXPORTED_RUNTIME_METHODS=cwarp")
switch("passL", "-O3 -g2 -s ASYNCIFY=1 -s WASM=1 -s MODULARIZE -s DETERMINISTIC=1 -s NODERAWFS=0 -s FORCE_FILESYSTEM=1 -s NO_EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS='_malloc','_main' -s EXPORTED_RUNTIME_METHODS=cwarp")
switch("passL", "-o " & outputName)
