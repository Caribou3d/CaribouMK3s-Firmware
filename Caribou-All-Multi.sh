#!/bin/bash
#  Will build all variants as multi language and final GOLD version
#  with build_number from configruatrion.h and output extra information,
#  delete lang build temporary files, not keep Configuration_prusa..
./PF-build.sh -d GOLD -c 1 -p 1 -l ALL -v All
