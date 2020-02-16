#!/bin/sh
set -e
echo "Beginning Build:"
rm -r dist
mkdir -p dist
cd ../ffmpeg
echo "emconfigure"
export EMCC_WASM_BACKEND=1
export EMCC_EXPERIMENTAL_USE_LLD=1
emconfigure ./configure --cc="emcc" --cxx="em++" --ar="emar" --ranlib="emranlib" --prefix=$(pwd)/../WasmVideoPlayer/dist --enable-cross-compile --target-os=none \
        --arch=x86_64 --cpu=generic --enable-gpl --enable-version3 --disable-avdevice --disable-swresample --disable-postproc --disable-avfilter \
        --disable-programs --disable-logging --disable-everything --enable-avformat --enable-decoder=hevc --enable-decoder=h264 --enable-decoder=aac \
        --disable-ffplay --disable-ffprobe --disable-x86asm --disable-inline-asm --disable-asm --disable-doc --disable-devices --disable-network --disable-hwaccels \
        --disable-parsers --disable-bsfs --disable-debug --enable-protocol=file --enable-demuxer=mov --enable-demuxer=flv --disable-indevs --disable-outdevs --disable-pthreads

sed -i .bak 's/HAVE_CBRT 0/HAVE_CBRT 1/g' ./config.h
sed -i .bak 's/HAVE_CBRTF 0/HAVE_CBRTF\ 1/g' ./config.h
sed -i .bak 's/HAVE_COPYSIGN 0/HAVE_COPYSIGN 1/g' ./config.h
sed -i .bak 's/HAVE_ERF 0/HAVE_ERF 1/g' ./config.h
sed -i .bak 's/HAVE_HYPOT 0/HAVE_HYPOT 1/g' ./config.h
sed -i .bak 's/HAVE_ISFINITE 0/HAVE_ISFINITE 1/g' ./config.h
sed -i .bak 's/HAVE_ISNAN 0/HAVE_ISNAN 1/g' ./config.h
sed -i .bak 's/HAVE_LRINT 0/HAVE_LRINT 1/g' ./config.h
sed -i .bak 's/HAVE_LRINTF 0/HAVE_LRINTF 1/g' ./config.h
sed -i .bak 's/HAVE_RINT 0/HAVE_RINT 1/g' ./config.h
sed -i .bak 's/HAVE_ROUND 0/HAVE_ROUND 1/g' ./config.h
sed -i .bak 's/HAVE_ROUNDF 0/HAVE_ROUNDF 1/g' ./config.h
sed -i .bak 's/HAVE_TRUNC 0/HAVE_TRUNC 1/g' ./config.h
sed -i .bak 's/HAVE_TRUNCF 0/HAVE_TRUNCF 1/g' ./config.h

if [ -f "Makefile" ]; then
  echo "make clean"
  emmake make clean
fi
echo "make"
emmake make
echo "make install"
emmake make install
cd ../WasmVideoPlayer
./build_decoder_wasm.sh
