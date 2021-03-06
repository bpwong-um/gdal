#!/bin/sh

set -e

export chroot="$PWD"/bionic
export LC_ALL=en_US.utf8

chroot "$chroot" sh -c "cd $PWD/autotest/cpp && make quick_test"
# Compile and test vsipreload
chroot "$chroot" sh -c "cd $PWD/autotest/cpp && make vsipreload.so"
# Run all the Python autotests

# Run ogr_fgdb test in isolation due to likely conflict with libxml2
chroot "$chroot" sh -c "cd $PWD/autotest/ogr && python ogr_fgdb.py && cd ../../.."
rm autotest/ogr/ogr_fgdb.py

# Fails with ERROR 1: OGDI DataSource Open Failed: Could not find the dynamic library "vrf"
rm autotest/ogr/ogr_ogdi.py

chroot "$chroot" sh -c "cd $PWD/autotest && python run_all.py"