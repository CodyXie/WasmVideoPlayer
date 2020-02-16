rm -rf wasmdecoder.wasm wasmdecoder.js
export TOTAL_MEMORY=67108864
export EXPORTED_FUNCTIONS="[ \
    '_initDecoder', \
    '_uninitDecoder', \
    '_openDecoder', \
    '_closeDecoder', \
    '_sendData', \
    '_decodeOnePacket', \
    '_seekTo', \
    '_main',
    '_malloc',
    '_free'
]"

echo "Running Emscripten..."
emcc decoder.c dist/lib/libavformat.a dist/lib/libavcodec.a dist/lib/libavutil.a dist/lib/libswscale.a \
    -O3 \
    --llvm-lto 3 \
    -I "dist/include" \
    -s WASM=1 \
    -s MODULARIZE=1 -s EXPORT_NAME=DecoderModule -s EXPORT_ES6=1 -s USE_ES6_IMPORT_META=0 \
    -s TOTAL_MEMORY=${TOTAL_MEMORY} \
    -s EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS}" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="['addFunction']" \
    -s RESERVED_FUNCTION_POINTERS=14 \
    -s FORCE_FILESYSTEM=1 \
    -o wasmdecoder.js

echo "Finished Build"
