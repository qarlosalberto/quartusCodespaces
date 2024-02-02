#!/usr/bin/env bash

set -ex

apt --yes install python3
apt --yes install python3-pip
pip3 install vunit_hdl
apt --yes install git
apt --yes install net-tools
