#!/bin/bash

if [ -z "$SCRIPT_PATH" ]; then
	SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
fi

	# Debranding
	# Reset url
	sed -i -e 's/"Caribou3d.com"/"prusa3d.com"/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# reset Company name
	sed -i -e 's/"\\n Caribou3d Research\\n   and Development\\n%20.20S"/"\\n Original Prusa i3\\n   Prusa Research\\n%20.20S"/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# reset FRIMWARE_NAME
	sed -i -e 's/"FIRMWARE_NAME:Caribou-Firmware "/"FIRMWARE_NAME:Prusa-Firmware "/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# reset FIRMWARE_URL
	sed -i -e "s/https:\/\/github.com\/Caribou3d\/Caribou-Firmware/https:\/\/github.com\/prusa3d\/Prusa-Firmware/g" $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# readd forum and help
	sed -i -e 's/\/\/MENU_ITEM_BACK_P(_i("forum.prusa3d.com"))*/MENU_ITEM_BACK_P(_i("forum.prusa3d.com"))/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	sed -i -e 's/\/\/MENU_ITEM_BACK_P(_i("howto.prusa3d.com"))*/MENU_ITEM_BACK_P(_i("howto.prusa3d.com"))/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# reset MSG_WIZZARD_WELCOME and WELCOME_MSG
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/Firmware/messages.cpp
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang/po/Firmware.pot
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_cs.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_de.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_es.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_fr.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_hu.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_hr.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_it.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_nl.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_no.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_pl.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_ro.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_sk.po
	sed -i -e "s/Caribou/Original Prusa i3/g" $SCRIPT_PATH/lang//po/Firmware_sv.po
	# End Debranding

