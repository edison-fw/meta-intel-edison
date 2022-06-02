SUMMARY = "Fast Base64 stream encoder/decoder"
HOMEPAGE = "https://github.com/aklomp/base64"
DESCRIPTION = "This is an implementation of a base64 stream encoding/decoding\
library in C99 with SIMD (AVX2, NEON, AArch64/NEON, SSSE3, SSE4.1, SSE4.2, AVX)\
and OpenMP acceleration. It also contains wrapper functions to encode/decode\
simple length-delimited strings.\
\
The libbase64 package probides base64, a simple standalone encoder. For\
testing libbase64-tools provides benchmark and test_base64.\
"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5e2bba16788d1d45efffc576d7a50360"

SRC_URI = "git://github.com/aklomp/base64.git;branch=master;protocol=https"
SRC_URI:append = " file://0001-When-building-with-OpenMP-support-link-to-openmp-lib.patch"
SRC_URI:append = " file://0001-Install-test-tools.patch"
SRC_URI:append = " file://0001-Build-base64.patch"
SRC_URI:append = " file://0001-cmake-Add-policies-to-shutup-warnings.patch"
SRC_URI:append = " file://0001-Require-cmake-version-3.10.2.patch"
SRC_URI:append = " file://0001-Disable-building-tests-by-default.patch"
SRC_URI:append = " file://0001-Only-build-CLI-on-supported-platforms.patch"

SRCREV = "f8fc2176b47197045aa180e199708087385a1303"

S = "${WORKDIR}/git"

inherit cmake

RDEPENDS:libbase64 += " libgomp"

EXTRA_OECMAKE ?= "-DBASE64_WITH_OpenMP=1 -DBASE64_BUILD_TESTS=1 -DCMAKE_BUILD_TYPE=Release"

# this may need some refining
BASE64_FEATURES +=  "${@bb.utils.contains('TUNE_FEATURES', 'skylake', 'SSE AVX', '', d)}"
BASE64_FEATURES +=  "${@bb.utils.contains('TUNE_FEATURES', 'corei7', 'SSE', '', d)}"
BASE64_FEATURES +=  "${@bb.utils.contains('TUNE_FEATURES', 'corei2', 'SSE', '', d)}"

EXTRA_OECMAKE += " \
    ${@bb.utils.contains('BASE64_FEATURES', 'SSE', '-DBASE64_WITH_SSSE3=1', '-DBASE64_WITH_SSSE3=0', d)} \
    ${@bb.utils.contains('BASE64_FEATURES', 'AVX', '-DBASE64_WITH_AVX2=1 -DBASE64_WITH_AVX=1', '-DBASE64_WITH_AVX2=0 -DBASE64_WITH_AVX=0', d)} \
    ${@bb.utils.contains('BASE64_FEATURES', 'SSE4', '-DBASE64_WITH_SSE41=1 -DBASE64_WITH_SSE42=1', '-DBASE64_WITH_SSE41=0 -DBASE64_WITH_SSE42=0', d)} \
"

BBCLASSEXTEND = "native nativesdk"

PACKAGES =+ "${PN}-tools"
FILES:${PN}-tools = "${bindir}/benchmark ${bindir}/test_base64"
