import AoLoader from "@permaweb/ao-loader";
import fs from "fs";

async function main() {
  const wasmBinary = fs.readFileSync("hello.wasm");
  console.log({wasmBinary})
  const options = {
    format: "wasm32-unknown-emscripten3",
    inputEncoding: "JSON-1",
    outputEncoding: "JSON-1", 
    memoryLimit: "524288000", // in bytes
    computeLimit: 9e12.toString(),
    extensions: []
  }
  const handle = await AoLoader(wasmBinary, options);
  console.log(handle)
  const result = await handle();
  console.log(result);
}

main();
