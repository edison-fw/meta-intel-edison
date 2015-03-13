# Add resize2fs tool


EXTRA_OECONF += "\
  --enable-resizer \
"

PACKAGES =+ "e2fsprogs-resize2fs"

FILES_e2fsprogs-resize2fs = "${base_sbindir}/resize2fs"

