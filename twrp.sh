#!/bin/bash
#
# TWRP Build Script V1.0
# Coded by AnanJaser1211 @2019
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Main Dir
CR_DIR=$(pwd)
# Thread count
CR_JOBS=9
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export USE_CCACHE=1
export LANG=C
##########################################
# Device specific Variables [SM-G930]
CR_DEVICE=herolte
# Device specific Variables [SM-G935]
CR_DEVICE=hero2lte
##########################################

# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"    
     make clean && make mrproper        
else
     echo "Dirty Build"        
fi

BUILD_RECOVERY()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building Recovery for $CR_DEVICE"
	repo sync --force-sync
    lunch omni_$TARGET-userdebug
	make recoveryimage -j$CR_JOBS
	echo " "
	echo "----------------------------------------------"
}
BUILD_EXPORT()
{
	echo "----------------------------------------------"
	echo " "
	echo "Copying Recovery.img for $CR_DEVICE"
    echo " "
    echo "----------------------------------------------"    
}

# Main Menu
PS3='Please select your option (1-6): '
menuvar=("herolte" "hero2lte" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "herolte")
            clear
            echo "Starting $CR_DEVICE kernel build..."
            BUILD_RECOVERY
            BUILD_EXPORT
            echo " "
            echo "----------------------------------------------"
            echo "$CR_DEVICE Recovery build finished."
            echo "$CR_DEVICE Ready at $CR_OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "hero2lte")
            clear
            echo "Starting $CR_DEVICE kernel build..."
            BUILD_RECOVERY
            BUILD_EXPORT
            echo " "
            echo "----------------------------------------------"
            echo "$CR_DEVICE Recovery build finished."
            echo "$CR_DEVICE Ready at $CR_OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
