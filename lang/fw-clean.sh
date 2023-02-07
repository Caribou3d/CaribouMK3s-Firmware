#!/bin/bash
#
# Version 1.0.1 Build 11
#
# fw-clean.sh - multi-language support script
#  Remove all firmware output files from lang folder.
#
#############################################################################
# Change log:
# 9 June 2020, 3d-gussner, Added version and Change log
# 9 June 2020, 3d-gussner, colored output
#############################################################################
# 21 June 2018, XPila,      Initial
# 11 Sep. 2018, XPila,      Lang update, french translation
#                           resized reserved space
# 18 Oct. 2018, XPila,      New lang, arduino 1.8.5 - fw-clean.sh and lang-clean.sh fix
# 10 Dec. 2018, jhoblitt,   make all shell scripts executable
# 26 Jul. 2019, leptun,     Fix shifted languages. Use \n and \x0a
# 14 Sep. 2019, 3d-gussner, Prepare adding new language
# 01 Mar. 2021, 3d-gussner, Move `Dutch` language parts
# 22 Mar. 2021, 3d-gussner, Move Dutch removing part to correct loaction
# 17 Dec. 2021, 3d-gussner, Use one config file for all languages
# 11 Jan. 2022, 3d-gussner, Added version and Change log
#                           colored output
#                           Use `git rev-list --count HEAD fw-clean.sh`
#                           to get Build Nr
# 25 Jan. 2022, 3d-gussner, Update documentation
#############################################################################
# Config:
if [ -z "$CONFIG_OK" ]; then eval "$(cat config.sh)"; fi
if [ -z "$CONFIG_OK" ] | [ $CONFIG_OK -eq 0 ]; then echo "$(tput setaf 1)Config NG!$(tput sgr0)" >&2; exit 1; fi
set -e

# Config
if [ -z "$CONFIG_OK" ]; then source config.sh; fi
if [ -z "$CONFIG_OK" -o "$CONFIG_OK" -eq 0 ]; then echo "$(tput setaf 1)Config NG!$(tput sgr0)" >&2; exit 1; fi

# Clean the temporary directory
TMPDIR=$(dirname "$0")/tmp
rm -rf "$TMPDIR"

# Remove internationalized firmware files
rm -f "${INTLHEX}"*.hex
