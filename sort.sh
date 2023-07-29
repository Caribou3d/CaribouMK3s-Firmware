#!/bin/bash

##################################################################
# This script sorts generated Caribou hex files in differnt folders
#
# You can add two arguments <Start_path> <Destiontion_Path>
# <Start_path> defines to folder to be searched
# <Destination_Path> defines the folder where the files will be placed
#
# Example: ./sort.sh ../PF-build-hex/FW381-Build2869 ../PF-build-hex/Firmware-381-Build2869
#          The script will search the files in ./FW381-Build2869 and copy them to the destination ../Firmware-381-Build2869
#
# V1.2
#
# Change log
# 17 Dec 2019, 3d-gussner, Initial version
# 18 Dec 2019, 3d-gussner, add arguments $1 = Start path and $2 Destination path
# 17 May 2020, 3d-gussner, Sorting of stock Prusa + OLED was missing thanks to @n4mb3r0n3
# 09 Sep 2020, 3d-gussner, Rebranding Caribou3d
# 10 Sep 2020, 3d-gussner, fix some sorting issues due to new naming convention
# 11 Jul 2021, wschadow, added LGX, added folders for Prusa and Caribou extruders
# 18 Jul 2021, wschadow, a zip file of the sorted files is generated
# 14 Feb 2020, wschadow, added LGXM and LGXMM, only sort and zip .elf files
# 11 Apr 2022, wschadow, updated output path and name of combined zip file
# 29 Jul 2023, wschadow, added sorting of REVO files
#
# Folder tree:
#.
#├── Caribou220
#│   ├── MK25
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK25S
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK3
#│   │   │── BONDTECH
#│   │   │   ├── E3D: V6 REVO / REVO HF
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   └── MK3S
#│       │── BONDTECH
#│       │    ├── E3D: V6 REVO / REVO HF
#│       │    ├── MOSQUITO
#│       │    └── MOSQUITO_MAGNUM
#│       │── Caribou
#│       ├── LGXC
#        └── LGXM
#├── Caribou320
#│   ├── MK25
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK25S
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK3
#│   │   │── BONDTECH
#│   │   │   ├── E3D: V6 REVO / REVO HF
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   └── MK3S
#│       │── BONDTECH
#│       │    ├── E3D: V6 REVO / REVO HF
#│       │    ├── MOSQUITO
#│       │    └── MOSQUITO_MAGNUM
#│       │── Caribou
#│       ├── LGXC
#        └── LGXM
#├── Caribou420
#│   ├── MK25
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK25S
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   ├── MK3
#│   │   │── BONDTECH
#│   │   │   ├── E3D: V6 REVO / REVO HF
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Caribou
#│   └── MK3S
#│       │── BONDTECH
#│       │    ├── E3D: V6 REVO / REVO HF
#│       │    ├── MOSQUITO
#│       │    └── MOSQUITO_MAGNUM
#│       │── Caribou
#│       ├── LGXC
#        └── LGXM
#└── Prusa210
#│   ├── MK25
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Prusa
#│   ├── MK25S
#│   │   │── BONDTECH
#│   │   │   ├── E3DV6
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Prusa
#│   ├── MK3
#│   │   │── BONDTECH
#│   │   │   ├── E3D: V6 REVO / REVO HF
#│   │   │   ├── MOSQUITO
#│   │   │   └── MOSQUITO_MAGNUM
#│   │   └── Prusa
#│   └── MK3S
#│       │── BONDTECH
#│       │    ├── E3D: V6 REVO / REVO HF
#│       │    ├── MOSQUITO
#│       │    └── MOSQUITO_MAGNUM
#│       │── Prusa
#│       ├── LGXC
#        └── LGXM
#
OS_FOUND=$( command -v uname)
case $( "${OS_FOUND}" | tr '[:upper:]' '[:lower:]') in
  linux*)
    TARGET_OS="linux"
   ;;
  msys*|cygwin*|mingw*)
    # or possible 'bash on windows'
    TARGET_OS='windows'
   ;;
  nt|win*)
    TARGET_OS='windows'
    ;;
  *)
    TARGET_OS='unknown'
    ;;
esac
# Windows
if [ $TARGET_OS == "windows" ]; then
    if [ $(uname -m) == "x86_64" ]; then
        echo "$(tput setaf 2)Windows 64-bit found$(tput sgr0)"
        Processor="64"
    elif [ $(uname -m) == "i386" ]; then
        echo "$(tput setaf 2)Windows 32-bit found$(tput sgr0)"
        Processor="32"
    fi
# Linux
elif [ $TARGET_OS == "linux" ]; then
    if [ $(uname -m) == "x86_64" ]; then
        echo "$(tput setaf 2)Linux 64-bit found$(tput sgr0)"
        Processor="64"
    elif [[ $(uname -m) == "i386" || $(uname -m) == "i686" ]]; then
        echo "$(tput setaf 2)Linux 32-bit found$(tput sgr0)"
        Processor="32"
    elif [ $(uname -m) == "aarch64" ]; then
        echo "$(tput setaf 2)Linux aarch64 bit found$(tput sgr0)"
        Processor="aarch64"
    fi
else
    echo "$(tput setaf 1)This script doesn't support your Operating system!"
    echo "Please use Linux 64-bit or Windows 10 64-bit with Linux subsystem / git-bash"
    echo "Read the notes of build.sh$(tput sgr0)"
    exit 1
fi
# Set arrays for script
# Array of companies
declare -a CompanyArray=( "Caribou" "Prusa" )
# Array of printer types
declare -a TypesArray=( MK3S MK3 MK25S MK25 )
# Array of printer heights
declare -a HeightsArray=( 220 320 420)
# Array of Bondtech folder names
declare -a BondtechArray=( E3DV6 E3DREVO MOSQUITO MOSQUITO_MAGNUM )
# End of set arrays


# Main script

if [ -z "$1" ] ; then
	Start_Path="."
else
	Start_Path=$1
fi

if [ -z "$2" ] ; then
	Destination_Path="."
else
	Destination_Path=$2
fi

echo "Start Path: "$Start_Path
echo "Dest. Path: "$Destination_Path

# Loop for printer types
for COMPANY in ${CompanyArray[@]}; do
	echo "Start $COMPANY"
	for TYPE in ${TypesArray[@]}; do
		# Loop for printer heights
		if [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			# Loop for Bondtech types
			for BONDTECH_TYPE in ${BondtechArray[@]}; do
				# Create all directories, see Folder tree above
				mkdir -p $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE
				# Link files short names to folder long names
				case $BONDTECH_TYPE in
					E3DV6)
					# For Bondtech E3DV6
					BONDTECH_SHORT='BE'
					# At this moment we don't use another version
					BONDTECH_SHORT2='BE'
				;;
					E3DREVO)
					# For Bondtech E3D REVO
					BONDTECH_SHORT='BER'
					# At this moment we don't use another version
					BONDTECH_SHORT2='BERH'
				;;
					MOSQUITO)
					# For Bondtech MOSQUITO with E3D thermistor
					BONDTECH_SHORT='BM'
					# For Bondtech MOSQUITO with Slice engineering thermistor
					BONDTECH_SHORT2='BMH'
				;;
					MOSQUITO_MAGNUM)
					# For Bondtech MOSQUITO_MAGNUM with E3D thermistor
					BONDTECH_SHORT='BMM'
					# For Bondtech MOSQUITO_MAGNUM with Slice engineering thermistor
					BONDTECH_SHORT2='BMMH'
				;;
				esac
				# Find all Bondtech hex files and copy them to destination folder sorted by Type, Height and Bontech txpe.
				# BONDTECH_SHORT -> Bondtech folder name
				find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-$BONDTECH_SHORT-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGHT/$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE \;
				# Find other Bondtech hex files and copy them to destination folder sorted By Type, Height and Bontech txpe.
				# BONDTECH_SHORT2 -> Bondtech folder name
				find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-$BONDTECH_SHORT2-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGH-$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE \;
			done
			if [ $TYPE == "MK3S" ]; then
			    # Find all LGXC files and copy them to the destination folder
			    mkdir -p $Destination_Path/$COMPANY$HEIGHT/$TYPE/LGXC
			    find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-LGXC-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGH-$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/LGXC \;
				# Find all LGM and LGMM files and copy them to the desitnation folder
			    mkdir -p $Destination_Path/$COMPANY$HEIGHT/$TYPE/LGXM
			    find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-LGM-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGH-$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/LGXM \;
			    find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-LGMM-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGH-$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/LGXM \;
			fi
			# Find rest hex files and copy them to destination folder sorted by Type and Height
		    mkdir -p $Destination_Path/$COMPANY$HEIGHT/$TYPE/$COMPANY
			find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGHT/$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/$COMPANY \;
			find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-REVO*-Build*.hex" -type f -not -path "$Destination_Path/$COMPANY$HEIGHT/$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/$COMPANY \;
		done
	done
done

echo
echo '   ... done'

# =========================================================================================================
# delete empty subdirectories
find $Destination_Path -type d -empty -delete

# =========================================================================================================
# create zip-file for configuration
echo
echo 'creating zip file of sorted hex-files ....'
echo
if [ $TARGET_OS == "windows" ]; then
    zip a $Destination_Path/$ZIPNAME.zip  $Destination_Path/* | tail -4
else
 	ZIPNAMETMP=${Destination_Path%*/}
	ZIPNAME=${ZIPNAMETMP##*/}
	pushd $Destination_Path
	zip -r $Destination_Path/$ZIPNAME.zip  * | tail -4
	popd
fi
echo
echo '   ... done'
