DESCRIPTION = "Open Source multimedia player."
SECTION = "multimedia"
HOMEPAGE = "http://www.mplayerhq.hu/"
DEPENDS = "libtheora ffmpeg zlib libpng jpeg liba52 freetype fontconfig alsa-lib lzo ncurses lame pulseaudio \
	   ${@base_conditional('ENTERPRISE_DISTRO', '1', '', 'libmad liba52 lame', d)}"

RDEPENDS_${PN} = "mplayer-common"
PROVIDES = "mplayer"
RPROVIDES_${PN} = "mplayer"
RCONFLICTS_${PN} = "mplayer"

LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d32239bcb673463ab874e80d47fae504"

SRC_URI = "git://repo.or.cz/mplayer.git;protocol=git;branch=master \
           file://cross.compile.codec-cfg.patch \
"

SRCREV = "e3f5043233336d8b4b0731c6a8b42a8fda5535ac"

ARM_INSTRUCTION_SET = "arm"

PV = "2.0+gitr${SRCPV}"
PR = "r8"

PARALLEL_MAKE = ""

S = "${WORKDIR}/git"

FILES_${PN} = "${bindir}/mplayer ${libdir} /usr/etc/mplayer/"
CONFFILES_${PN} += "/usr/etc/mplayer/input.conf \
                    /usr/etc/mplayer/example.conf \
                    /usr/etc/mplayer/codecs.conf \
                   "

inherit autotools pkgconfig

EXTRA_OECONF = " \
	--prefix=/usr \
	--mandir=${mandir} \
	--target=${SIMPLE_TARGET_SYS} \
	\
        --disable-fontconfig \
        --disable-libass \
	--disable-lirc \
	--disable-lircc \
	--disable-joystick \
	--disable-vm \
	--disable-xf86keysym \
	--disable-tv \
	--disable-tv-v4l1 \
	--disable-tv-v4l2 \
	--disable-tv-bsdbt848 \
	--enable-rtc \
	--disable-networking \
	--disable-smb \
	--disable-live \
	--disable-dvdnav \
	--disable-dvdread \
	--disable-dvdread-internal \
	--disable-libdvdcss-internal \
	--disable-cdparanoia \
	--enable-freetype \
	--disable-sortsub \
	--disable-fribidi \
	--disable-enca \
	--disable-ftp \
	--disable-vstream \
	\
	--disable-gif \
	--disable-png \
	--disable-jpeg \
	--disable-libcdio \
	--disable-qtx \
	--disable-xanim \
	--disable-real \
	--disable-xvid \
	\
        --disable-mpg123 \
	--disable-speex \
	--enable-theora \
	--disable-ladspa \
	--disable-libdv \
	--disable-mad \
	--disable-xmms \
	--disable-musepack \
	\
	--disable-gl \
	--disable-vesa \
	--disable-svga \
	--disable-sdl \
	--disable-aa \
	--disable-caca \
	--disable-ggi \
	--disable-ggiwmh \
	--disable-directx \
	--disable-dxr3 \
	--disable-dvb \
	--disable-mga \
	--disable-xmga \
	--disable-xv \
	--disable-vm \
	--disable-xinerama \
	--disable-x11 \
	--disable-fbdev \
	--disable-3dfx \
	--disable-tdfxfb \
	--disable-s3fb \
	--disable-directfb \
	--disable-bl \
	--disable-tdfxvid \
	--disable-tga \
	--disable-pnm \
	--disable-md5sum \
	\
	--disable-alsa \
	--disable-ossaudio \
	--disable-arts \
	--disable-esd \
	--enable-pulse \
	--disable-jack \
	--disable-openal \
	--disable-nas \
	--disable-sgiaudio \
	--disable-sunaudio \
	--disable-win32waveout \
	--enable-select \
	\
        --extra-libs=' -lstdc++ -lvorbis ' \
"

EXTRA_OECONF_append_armv6 = " --enable-armv6"
EXTRA_OECONF_append_armv7a = " --enable-armv6 --enable-neon"

FULL_OPTIMIZATION = "-fexpensive-optimizations -fomit-frame-pointer -frename-registers -O4 -ffast-math"
BUILD_OPTIMIZATION = "${FULL_OPTIMIZATION}"

CFLAGS_append = " -I${S}/libdvdread4 "

do_configure() {
	sed -i 's|/usr/include|${STAGING_INCDIR}|g' ${S}/configure
	sed -i 's|/usr/lib|${STAGING_LIBDIR}|g' ${S}/configure
	sed -i 's|/usr/\S*include[\w/]*||g' ${S}/configure
	sed -i 's|/usr/\S*lib[\w/]*||g' ${S}/configure
	sed -i 's|_install_strip="-s"|_install_strip=""|g' ${S}/configure
	sed -i 's|HOST_CC|BUILD_CC|' ${S}/Makefile

	export SIMPLE_TARGET_SYS="$(echo ${TARGET_SYS} | sed s:${TARGET_VENDOR}::g)"
	./configure ${EXTRA_OECONF}
}

do_compile () {
	oe_runmake
}

do_install_append() {
        install -d ${D}/usr/etc/mplayer
        install ${S}/etc/input.conf ${D}/usr/etc/mplayer/
        install ${S}/etc/example.conf ${D}/usr/etc/mplayer/
        install ${S}/etc/codecs.conf ${D}/usr/etc/mplayer/
}
