# nodejs takes a long time to build and benifits from as much parallel
# makes as possible while compiling. However in the linking stage it
# will try to link 5 executables simultaneosly each consuming 4GB RAM
# unless you have 20GB RAM available adding nodejs to you image will
# be very time consuming. One way to fix this is by adding to you
# local.conf file:

# Restrict parallel build for nodjs
#PARALLEL_MAKE:pn-nodejs = "-j 1"
#PARALLEL_MAKE:pn-nodejs-native = "-j 1"

# This will also slow down the compile phase.

# A bit more targeted is the following which will leave parallel make
# as is, but serialize the linkers.

EXTRA_OEMAKE:prepend = "\
LINK='flock /tmp ${CXX}' \
"
