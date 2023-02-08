#!/bin/bash

################################################################################
# Description:
# Creates special variants
# TYPE		= Printer type			: MK25, MK25S, MK3, MK3S
#
# BOARD		= Controller board		: EINSy10a, RAMBo13a
#
# HEIGHT	= Height of printer		: 210, 220, 320, 420
#
# MOD 		= Modification			: BE   = Bondtech Extruder for Prusa
#                                     BM   = Bondtech Extruder for Prusa with Mosquito Hotend
#                                     BMH  = Bondetch Extruder for Prusa with Mosquito and Slice Hight temp Thermistor
#                                     BMM  = Bondtech Extruder for Prusa with Mosquito Magnum Hotend
#                                     BMMH = Bondetch Extruder for Prusa with Mosquito Magnum and Slice Hight temp Thermistor
#                                     LGX  = Bondtech LGX Extruder for Prusa with copperfield
#                                     LM   = Bondtech LGX Extruder for Prusa with Mosquito Hotend
#                                     LMM  = Bondtech LGX Extruder for Prusa with Mosquito Magnum Hotend
# TypesArray is an array of printer types
# HeightsArray is an array of printer hights
# ModArray is an array of printer mods
#
#
# Version 1.0.15
################################################################################
# 3 Jul 2019, vertigo235, Inital varaiants script
# 8 Aug 2019, 3d-gussner, Modified for Caribou needs
# 14 Sep 2019, 3d-gussner, Added MOD BMSQ and BMSQHT Bondtech Mosquito / High Temperature
# 20 Sep 2019, 3d-gussner, New Naming convention for the variants.
#                          As we just support EINSy10a and RAMBo13a boards
# 01 Oct 2019, 3d-gussner, Fixed MK2.5 issue
# 12 Oct 2019, 3d-gussner, Add OLED display support
# 12 Nov 2019, 3d-gussner, Update Bondtech Extruder variants, as they are longer than Caribou Extruder
#                          Also implementing Bondtech Mosquito MMU length settings
# 14 Nov 2019, 3d-gussner, Merge OLED as default
# 15 Nov 2019, 3d-gussner, Fix Bondtech Steps on MK25 and MK25s. Thanks to Bernd pointing it out.
# 30 Dec 2019, 3d-gussner, Fix MK2.5 y motor direction
# 08 Feb 2020, 3d-gussner, Add Prusa MK25/s and MK3/s with OLED and with/without Bondtech
# 19 Apr 2020, 3d-gussner, Add #define EXTRUDER_DESIGN R3 in varaiants files for Caribou, Bear, Bondtech extruder
# 02 Sep 2020, 3d-gussner, Fix OLED display also for Prusa printers
# 09 Sep 2020, 3d-gussner, Rebranding Caribou and new naming convention
# 11 Sep 2020, 3d-gussner, Change EXTRUDER_ALTFAN_SPEED_SILENT speed
# 09 May 2021, 3d-gussner, Add Bondtech LGXC support
# 13 Feb 2022, wschadow, added LGXM and LGXMM support
################################################################################

# Constants
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENTDIR="$( pwd )"
TODAY=$(date +'%Y%m%d')
#

# Set default constants
TYPE="MK3"
MOD=""
BOARD="EINSy10a"
HEIGHT=210
BASE="1_75mm_$TYPE-$BOARD-E3Dv6full.h"
BMGHeightDiff=-3 #Bondtech extruders are bit higher than stock one
LGXHeightDiff=6 #Bondtech LGX is shorter than Prusa extruder
LGXMHeightDiff=-4 #Bondtech LGX is shorter than Prusa extruder

# Arrays
declare -a CompanyArray=( "Caribou" "Prusa" )
declare -a TypesArray=( "MK3" "MK3S" "MK25" "MK25S" )
declare -a HeightsArray=( 220 320 420)
declare -a ModArray=( "BE" "BM" "BMM" "BMH" "BMMH")
#

# Cleanup old Caribou variants
ls Caribou*
ls Prusa*
echo " "
echo "Existing Caribou varaiants will be deleted. Press CRTL+C to stop"
sleep 1
rm Caribou*
rm Prusa*

##### MK25/MK25S/MK3/MK3S Variants
for COMPANY in ${CompanyArray[@]}; do
	echo "Start $COMPANY"
	for TYPE in ${TypesArray[@]}; do
		echo "Type: $TYPE"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		BASE="1_75mm_$TYPE-$BOARD-E3Dv6full.h"
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			VARIANT="$COMPANY$HEIGHT-$TYPE.h"
			#echo $COMPANY
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $VARIANT
			#sleep 10
			cp ${BASE} ${VARIANT}
			ls
			# Printer Display Name
			if [ $TYPE == "MK25" ]; then
				PRUSA_TYPE="MK2.5"
			elif [ $TYPE == "MK25S" ]; then
				PRUSA_TYPE="MK2.5S"
			else
				PRUSA_TYPE=$TYPE
			fi
			if [ $COMPANY == "Caribou" ]; then
				# Modify printer name
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'"/g' ${VARIANT}
				# Enable Extruder_Design_R3 for Caribou
				sed -i -e "s/\/\/#define EXTRUDER_DESIGN_R3*/#define EXTRUDER_DESIGN_R3/g" ${VARIANT}
				# Inverted Y-Motor only for MK3
				if [ $BOARD == "EINSy10a" ]; then
					sed -i -e "s/^#define INVERT_Y_DIR 0*/#define INVERT_Y_DIR 0/g" ${VARIANT}
				fi
				# Printer Height
				sed -i -e "s/^#define Z_MAX_POS 210*/#define Z_MAX_POS ${HEIGHT}/g" ${VARIANT}
				# Disable PSU_Delta
				sed -i -e "s/^#define PSU_Delta*/\/\/#define PSU_Delta/g" ${VARIANT}
				if [ $TYPE == "MK3S" ] ; then
					sed -i -e "s/^#define EXTRUDER_ALTFAN_SPEED_SILENT 128*/#define EXTRUDER_ALTFAN_SPEED_SILENT 255/g" ${VARIANT}
				fi
			fi
				# Display Type
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY"

## MODS
echo "Start $COMPANY BE"
MOD="BE" ##Bondtech Prusa Edition Extruder for MK25/MK25S/MK3/MK3S
for COMPANY in ${CompanyArray[@]}; do
	echo $COMPANY
	for TYPE in ${TypesArray[@]}; do
		echo "Type: $TYPE Mod: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			BMGHEIGHT=$(( $HEIGHT + $BMGHeightDiff ))
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $BMGHEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				if [ $TYPE == "MK25" ]; then
					PRUSA_TYPE="MK2.5"
				elif [ $TYPE == "MK25S" ]; then
					PRUSA_TYPE="MK2.5S"
				else
					PRUSA_TYPE=$TYPE
				fi
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Enable Extruder_Design_R3 for Caribou
			sed -i -e "s/\/\/#define EXTRUDER_DESIGN_R3*/#define EXTRUDER_DESIGN_R3/g" ${VARIANT}
			# Printer Height
			sed -i -e "s/^#define Z_MAX_POS ${HEIGHT}*/#define Z_MAX_POS ${BMGHEIGHT}/g" ${VARIANT}
			if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
				# E Steps for MK3 and MK3S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,280}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,415}/' ${VARIANT}
			elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
				# E Steps for MK25 and MK25S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,133}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,415}/' ${VARIANT}
			fi
			# Microsteps
			sed -i -e 's/#define TMC2130_USTEPS_E    32*/#define TMC2130_USTEPS_E    16/' ${VARIANT}
			# Filament Load Distances (BPE gears are farther from the hotend)
			sed -i -e 's/#define FILAMENTCHANGE_FIRSTFEED 70*/#define FILAMENTCHANGE_FIRSTFEED 80/' ${VARIANT}
			sed -i -e 's/#define LOAD_FILAMENT_1 "G1 E70 F400"*/#define LOAD_FILAMENT_1 "G1 E80 F400"/' ${VARIANT}
			sed -i -e 's/#define UNLOAD_FILAMENT_1 "G1 E-80 F7000"*/#define UNLOAD_FILAMENT_1 "G1 E-95 F7000"/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALRETRACT -80*/#define FILAMENTCHANGE_FINALRETRACT -95/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALFEED 70*/#define FILAMENTCHANGE_FINALFEED 80/' ${VARIANT}
			# Display Type
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
			# Enable Bondtech E3d MMU settings
			sed -i -e "s/\/\/#define BONDTECH_MK3S*/#define BONDTECH_MK3S/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BE"


echo "Start $COMPANY BM"
BASE_MOD=BE
MOD="BM" ##Bondtech Prusa Mosquito Edition for MK2.5S and MK3S
declare -a BMArray=( "MK3S" "MK25S")
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE-$BASE_MOD.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				PRUSA_TYPE=$TYPE
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Hotend Type
			sed -i -e 's/#define NOZZLE_TYPE "E3Dv6full"*/#define NOZZLE_TYPE "Mosquito"/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MK3S*/\/\/#define BONDTECH_MK3S/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_MOSQUITO*/#define BONDTECH_MOSQUITO/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BM"

echo "Start $COMPANY BMH"
BASE_MOD=BM
MOD="BMH" ##Bondtech Prusa Mosquito Edition for MK2.5S and MK3S with Slice High Temperature Thermistor

for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE-$BASE_MOD.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				PRUSA_TYPE=$TYPE
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Enable Slice High Temperature Thermistor
			sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
			# Change mintemp for Slice High Temperature Thermistor
			sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
		done
	done
done

for TYPE in ${BMQArray[@]}; do
	echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
	if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
		BOARD="EINSy10a"
	elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
		BOARD="RAMBo13a"
	else
		echo "Unsupported controller"
		exit 1
	fi
	for HEIGHT in ${HeightsArray[@]}; do
		BASE="$COMPANY$HEIGHT-$TYPE-$BASE_MOD.h"
		VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
		#echo $BASE
		#echo $TYPE
		#echo $HEIGHT
		echo $VARIANT
		cp ${BASE} ${VARIANT}
		# Modify printer name
		sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$Caribou$HEIGHT'-'$TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "Caribou'$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
		# Enable Slice High Temperature Thermistor
		sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
		# Change mintemp for Slice High Temperature Thermistor
		sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
	done
done
echo "End $COMPANY BMH"

echo "Start $COMPANY BMM"
BASE_MOD=BM
MOD="BMM" ##Bondtech Prusa Mosquito Magnum Edition for MK2.5S and MK3S
declare -a BMArray=( "MK3S" "MK25S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE-$BASE_MOD.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				PRUSA_TYPE=$TYPE
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Hotend Type
			sed -i -e 's/#define NOZZLE_TYPE "Mosquito"*/#define NOZZLE_TYPE "Mosquito Magnum"/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MOSQUITO*/\/\/#define BONDTECH_MOSQUITO/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_M_MAGNUM*/#define BONDTECH_M_MAGNUM/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BMM"

echo "Start $COMPANY BMMH"
BASE_MOD=BMM
MOD="BMMH" ##Bondtech Prusa Mosquito Magnum Edition with Slice High Temperature Thermistor
declare -a BMMArray=( "MK3S" "MK25S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [ "$TYPE" == "MK3S" ]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE-$BASE_MOD.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				PRUSA_TYPE=$TYPE
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'-'$BASE_MOD'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Enable Slice High Temperature Thermistor
			sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
			# Change mintemp for Slice High Temperature Thermistor
			sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BMMH"

echo "Start $COMPANY LGXC"
MOD="LGXC" ##Bondtech LGX Extruder with Copperhead hotend for MK3S
declare -a LGXCArray=( "MK3S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${LGXCArray[@]}; do
		echo "Type: $TYPE Mod: $MOD"
		if [ "$TYPE" == "MK3S" ]; then
			BOARD="EINSy10a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			LGXHEIGHT=$(( $HEIGHT + $LGXHeightDiff ))
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $LGXHEIGHT
			echo $VARIANT
			# Modify printer name
			cp ${BASE} ${VARIANT}
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				if [ $TYPE == "MK25" ]; then
					PRUSA_TYPE="MK2.5"
				elif [ $TYPE == "MK25S" ]; then
					PRUSA_TYPE="MK2.5S"
				else
					PRUSA_TYPE=$TYPE
				fi
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Hotend Type
			sed -i -e 's/#define NOZZLE_TYPE "E3Dv6full"*/#define NOZZLE_TYPE "Copperhead"/' ${VARIANT}
			# Disable Extruder_Design_R3 for Caribou
			sed -i -e "s/^#define EXTRUDER_DESIGN_R3*/\/\/#define EXTRUDER_DESIGN_R3/g" ${VARIANT}
            # Enable LGX
			sed -i -e "s/\/\/#define BONDTECH_LGXC*/#define BONDTECH_LGXC/g" ${VARIANT}
			# Printer Height
			sed -i -e "s/^#define Z_MAX_POS ${HEIGHT}*/#define Z_MAX_POS ${LGXHEIGHT}/g" ${VARIANT}
			if [ "$TYPE" == "MK3S" ]; then
				# E Steps for MK3 and MK3S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,280}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,410}/' ${VARIANT}
            fi
			sed -i -e 's/#define TMC2130_USTEPS_E    32*/#define TMC2130_USTEPS_E    16/' ${VARIANT}
			# Filament Load Distances (BPE gears are farther from the hotend)
			sed -i -e 's/#define LOAD_FILAMENT_1 "G1 E70 F400"*/#define LOAD_FILAMENT_1 "G1 E80 F400"/' ${VARIANT}
			sed -i -e 's/#define UNLOAD_FILAMENT_1 "G1 E-80 F7000"*/#define UNLOAD_FILAMENT_1 "G1 E-30 F7000"/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALRETRACT -80*/#define FILAMENTCHANGE_FINALRETRACT -40/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FIRSTFEED 70*/#define FILAMENTCHANGE_FIRSTFEED 5/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALFEED 25*/#define FILAMENTCHANGE_FINALFEED 20/' ${VARIANT}
			# Display Type
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
            # LGX PINDA xy offset
            sed -i -e "s/#define X_PROBE_OFFSET_FROM_EXTRUDER 23*/#define X_PROBE_OFFSET_FROM_EXTRUDER 22.25/g" ${VARIANT}
            sed -i -e "s/#define Y_PROBE_OFFSET_FROM_EXTRUDER 5*/#define Y_PROBE_OFFSET_FROM_EXTRUDER 11.5/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY LGXC"

echo "Start $COMPANY LGM"
MOD="LGM" ##Bondtech LGX Extruder with Mosquito hotend for MK3S
declare -a LGXMArray=( "MK3S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${LGXMArray[@]}; do
		echo "Type: $TYPE Mod: $MOD"
		if [ "$TYPE" == "MK3S" ]; then
			BOARD="EINSy10a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			LGXHEIGHT=$(( $HEIGHT + $LGXMHeightDiff ))
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $LGXHEIGHT
			echo $VARIANT
			# Modify printer name
			cp ${BASE} ${VARIANT}
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				if [ $TYPE == "MK25" ]; then
					PRUSA_TYPE="MK2.5"
				elif [ $TYPE == "MK25S" ]; then
					PRUSA_TYPE="MK2.5S"
				else
					PRUSA_TYPE=$TYPE
				fi
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Hotend Type
			sed -i -e 's/#define NOZZLE_TYPE "E3Dv6full"*/#define NOZZLE_TYPE "Mosquito"/' ${VARIANT}
			# Printer Height
			sed -i -e "s/^#define Z_MAX_POS ${HEIGHT}*/#define Z_MAX_POS ${LGXHEIGHT}/g" ${VARIANT}
			if [ "$TYPE" == "MK3S" ]; then
				# E Steps for MK3 and MK3S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,280}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,400}/' ${VARIANT}
            fi
			sed -i -e 's/#define TMC2130_USTEPS_E    32*/#define TMC2130_USTEPS_E    16/' ${VARIANT}
			# Filament Load Distances (BPE gears are farther from the hotend)
			sed -i -e 's/#define FILAMENTCHANGE_FIRSTFEED 70*/#define FILAMENTCHANGE_FIRSTFEED 80/' ${VARIANT}
			sed -i -e 's/#define LOAD_FILAMENT_1 "G1 E70 F400"*/#define LOAD_FILAMENT_1 "G1 E80 F400"/' ${VARIANT}
			sed -i -e 's/#define UNLOAD_FILAMENT_1 "G1 E-80 F7000"*/#define UNLOAD_FILAMENT_1 "G1 E-95 F7000"/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALRETRACT -80*/#define FILAMENTCHANGE_FINALRETRACT -95/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALFEED 70*/#define FILAMENTCHANGE_FINALFEED 80/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MK3S*/\/\/#define BONDTECH_MK3S/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_MOSQUITO*/#define BONDTECH_MOSQUITO/g" ${VARIANT}
			# Display Type
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY LGM"

echo "Start $COMPANY LGMM"
MOD="LGMM" ##Bondtech LGX Extruder with Mosquito Magnum hotend for MK3S
declare -a LGXMMArray=( "MK3S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${LGXMMArray[@]}; do
		echo "Type: $TYPE Mod: $MOD"
		if [ "$TYPE" == "MK3S" ]; then
			BOARD="EINSy10a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Caribou" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY$HEIGHT-$TYPE.h"
			VARIANT="$COMPANY$HEIGHT-$TYPE-$MOD.h"
			LGXHEIGHT=$(( $HEIGHT + $LGXMHeightDiff ))
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $LGXHEIGHT
			echo $VARIANT
			# Modify printer name
			cp ${BASE} ${VARIANT}
			if [ $COMPANY == "Caribou" ]; then
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY$HEIGHT'-'$TYPE'-'$MOD'"/g' ${VARIANT}
			else
				if [ $TYPE == "MK25" ]; then
					PRUSA_TYPE="MK2.5"
				elif [ $TYPE == "MK25S" ]; then
					PRUSA_TYPE="MK2.5S"
				else
					PRUSA_TYPE=$TYPE
				fi
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "Prusa i3 '$TYPE'-'$MOD'"/g' ${VARIANT}
			fi
			# Hotend Type
			sed -i -e 's/#define NOZZLE_TYPE "E3Dv6full"*/#define NOZZLE_TYPE "Mosquito Magnum"/' ${VARIANT}
			# Printer Height
			sed -i -e "s/^#define Z_MAX_POS ${HEIGHT}*/#define Z_MAX_POS ${LGXHEIGHT}/g" ${VARIANT}
			if [ "$TYPE" == "MK3S" ]; then
				# E Steps for MK3 and MK3S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,280}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,400}/' ${VARIANT}
            fi
			sed -i -e 's/#define TMC2130_USTEPS_E    32*/#define TMC2130_USTEPS_E    16/' ${VARIANT}
			# Filament Load Distances (BPE gears are farther from the hotend)
			sed -i -e 's/#define FILAMENTCHANGE_FIRSTFEED 70*/#define FILAMENTCHANGE_FIRSTFEED 80/' ${VARIANT}
			sed -i -e 's/#define LOAD_FILAMENT_1 "G1 E70 F400"*/#define LOAD_FILAMENT_1 "G1 E80 F400"/' ${VARIANT}
			sed -i -e 's/#define UNLOAD_FILAMENT_1 "G1 E-80 F7000"*/#define UNLOAD_FILAMENT_1 "G1 E-95 F7000"/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALRETRACT -80*/#define FILAMENTCHANGE_FINALRETRACT -95/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALFEED 70*/#define FILAMENTCHANGE_FINALFEED 80/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MK3S*/\/\/#define BONDTECH_MK3S/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_MOSQUITO*/#define BONDTECH_MOSQUITO/g" ${VARIANT}
			# Display Type
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY LGMM"
