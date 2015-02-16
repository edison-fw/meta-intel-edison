#!/bin/sh

#
# Cleanjournal script
#
# Copyright (c) 2014, Intel Corporation.
# Fabien Rodriguez <fabienx.rodriguez@intel.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#
# This script checks if the remaining space in root partition is lower than 10%.
# In that case, the corrupted journald entries (ended by '~') will be deleted
# one by one until remaining space becomes greater or equal to 10%.
# At each boot, the script is launched by systemd at startup.
#

# max allowed free space is 10%
max_allowed_free_space=10

# check remaining space and update clean_journal_needed variable
check_free_space() {
    current_free_space=$(df -h | grep /dev/root | awk '{print 100 - $5}' | sed 's/%//')
    if [ "$current_free_space" -lt "$max_allowed_free_space" ]; then
        clean_journal_needed=true
    else
        clean_journal_needed=false
    fi
}

check_free_space
if [ "$clean_journal_needed" = true ]; then
    # delete each journald corrupted entry
    # until remaining space becomes greater than 10%
    for corrupted_journal_file in $(find /var/log/journal/ -name '*~'); do
        rm "$corrupted_journal_file"
        check_free_space
        if [ "$clean_journal_needed" = false ]; then
            break
        fi
    done
fi

