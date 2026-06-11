#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package       : cytoolz
# Version       : 0.12.0
# Source repo   : https://github.com/pytoolz/cytoolz
# Tested on     : UBI:9.7
# Language      : Python
# Ci-Check      : True
# Script License: Apache License, Version 2 or later
# Maintainer    : Keerthana GR <Keerthana.G.R@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

# Variables
PACKAGE_NAME=cytoolz
PACKAGE_VERSION=${1:-0.12.0}
PACKAGE_URL=https://github.com/pytoolz/cytoolz
PACKAGE_DIR=cytoolz

# Install dependencies
yum install -y python3 python3-pip python3-devel git gcc gcc-c++ make

# Clone repository
git clone $PACKAGE_URL
cd $PACKAGE_DIR
git checkout $PACKAGE_VERSION

# Install Python dependencies (pin Cython to compatible version)
pip3 install "cython<3.0" toolz pytest setuptools wheel

# Install package using pip (with --no-build-isolation to use our pinned Cython)
if ! pip3 install --no-build-isolation . ; then
    echo "------------------$PACKAGE_NAME:Install_fails-------------------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_Fails"
    exit 1
fi

# Run tests
if ! pytest ; then
    echo "------------------$PACKAGE_NAME:Install_success_but_test_fails---------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub | Fail |  Install_success_but_test_Fails"
    exit 2
else
    echo "------------------$PACKAGE_NAME:Install_&_test_both_success-------------------------"
    echo "$PACKAGE_URL $PACKAGE_NAME"
    echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | GitHub  | Pass |  Both_Install_and_Test_Success"
    exit 0
fi

