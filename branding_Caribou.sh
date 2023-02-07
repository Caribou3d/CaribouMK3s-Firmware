#!/bin/bash

if [ -z "$SCRIPT_PATH" ]; then
	SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
fi
	# Branding
	# set Caribou3d url
	sed -i -e 's/"prusa3d.com"/"Caribou3d.com"/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# set Company name
	sed -i -e 's/"\\n Original Prusa i3\\n   Prusa Research\\n%20.20S"/"\\n Caribou3d Research\\n   and Development\\n%20.20S"/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# set FRIMWARE_NAME
	sed -i -e 's/"FIRMWARE_NAME:Prusa-Firmware "/"FIRMWARE_NAME:Caribou-Firmware "/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# set FIRMWARE_URL
	sed -i -e "s/https:\/\/github.com\/prusa3d\/Prusa-Firmware/https:\/\/github.com\/Caribou3d\/Caribou-Firmware/g" $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# remove forum and help
	grep --max-count=1 '//MENU_ITEM_BACK_P(_i("forum.prusa3d.com"))' $SCRIPT_PATH/Firmware/ultralcd.cpp || sed -i -e 's/MENU_ITEM_BACK_P(_i("forum.prusa3d.com"))*/\/\/MENU_ITEM_BACK_P(_i("forum.prusa3d.com"))/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	grep --max-count=1 '//MENU_ITEM_BACK_P(_i("howto.prusa3d.com"))' $SCRIPT_PATH/Firmware/ultralcd.cpp || sed -i -e 's/MENU_ITEM_BACK_P(_i("howto.prusa3d.com"))*/\/\/MENU_ITEM_BACK_P(_i("howto.prusa3d.com"))/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# set MSG_WIZZARD_WELCOME and WELCOME_MSG
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/Firmware/messages.cpp
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware.pot
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_cs.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_de.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_es.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_fr.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_hr.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_hu.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_it.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_nl.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_no.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_pl.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_ro.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_sk.po
	sed -i -e "s/Original Prusa i3/Caribou/g" $SCRIPT_PATH/lang/po/Firmware_sv.po
	# End Branding
