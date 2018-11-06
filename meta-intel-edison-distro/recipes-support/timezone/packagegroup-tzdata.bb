#
# Copyright (C) 2018 Exalon Delft B.V.
#

SUMMARY = "Meta package that pulls all timezones"

inherit packagegroup

RDEPENDS_packagegroup-tzdata = "\
    tzdata \
    tzdata-misc \
    tzdata-africa \
    tzdata-americas \
    tzdata-antarctica \
    tzdata-arctic \
    tzdata-asia \
    tzdata-atlantic \
    tzdata-australia \
    tzdata-europe \
    tzdata-pacific \
    "
