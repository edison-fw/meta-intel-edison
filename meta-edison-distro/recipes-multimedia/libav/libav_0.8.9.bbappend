# Disable features that have potential commercial licensing restrictions
EXTRA_OECONF += "\
    --disable-encoder=libmp3lame \
    --disable-decoder=mp3 \
    --disable-decoder=mp3adu \
    --disable-decoder=mp3adufloat \
    --disable-decoder=mp3float \
    --disable-decoder=mp3on4 \
    --disable-decoder=mp3on4float \
    --disable-muxer=mp3 \
    --disable-demuxer=mp3 \
    --disable-bsf=mp3_header_decompress \
    --disable-bsf=mp3_header_compress \
    \
    --disable-encoder=mpeg2video \
    --disable-decoder=mpeg2video \
    --disable-hwaccel=mpeg2_vaapi\
    --disable-hwaccel=mpeg2_dxva2\
    --disable-muxer=mpeg2dvd \
    --disable-muxer=mpeg2svcd \
    --disable-muxer=mpeg2video \
    --disable-muxer=mpeg2vob \
"
