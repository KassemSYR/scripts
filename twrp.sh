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
CR_REPO=.repo/local_manifests
# Thread count
CR_JOBS=$(nproc --all)
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export USE_CCACHE=1
export LANG=C
##########################################
# Device specific Variables [SM-G930]
CR_DEVICE_HERO=herolte
CR_SOURCE_HERO="ananjaser1211/android_device_samsung_hero"
CR_MANIFEST_HERO=herolte.xml
# Device specific Variables [SM-G935]
CR_DEVICE_HERO2=hero2lte
CR_SOURCE_HERO2="ananjaser1211/android_device_samsung_hero"
CR_MANIFEST_HERO2=hero2lte.xml
##########################################

BUILD_SYNC()
{
    echo "----------------------------------------------"
    echo " "
    echo "Checking for Dirs"    
    if [ ! -e $CR_DIR/$CR_REPO ]; then
        echo "Local manifests folder not found, Create it"
        mkdir .repo/local_manifests
    fi
    if [ -e $CR_DIR/$CR_REPO/$CR_MANIFEST ]; then
        echo "Removing old Trees"   
        rm -rf $CR_DIR/$CR_REPO/$CR_MANIFEST
        rm -rf $CR_DIR/device/samsung/$CR_DEVICE 
    fi
    echo "Generate Device manifest."
    echo '<?xml version="1.0" encoding="UTF-8"?>' >> $CR_REPO/$CR_MANIFEST
    echo '<manifest>' >> $CR_REPO/$CR_MANIFEST
    echo "  <project name="\"$CR_SOURCE\"" path="\"device/samsung/"$CR_DEVICE\"" remote="\"github\"" revision="\"$CR_DEVICE\""""" />" >> $CR_REPO/$CR_MANIFEST
    echo '</manifest>' >> $CR_REPO/$CR_MANIFEST
    echo "$CR_DEVICE Manifest generated, Sync...."
    # TWRP Repo Sync
    repo sync -c -j$CR_JOBS --force-sync --no-clone-bundle --no-tags
    if [ ! -e $CR_DIR/device/samsung/$CR_DEVICE ]; then
    exit 0;
    echo "$CR_DEVICE Sync failed! Please check repos."
    else
    if [ -e $CR_DIR/device/samsung/$CR_DEVICE ]; then
    echo "$CR_DEVICE Sync success! Building..." 
    fi
    fi
}   

BUILD_RECOVERY()
{
    echo "----------------------------------------------"
    echo " "
    echo "Building Recovery for $CR_DEVICE"
    lunch omni_$CR_DEVICE-userdebug
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
            CR_DEVICE=$CR_DEVICE_HERO
            CR_SOURCE=$CR_SOURCE_HERO
            CR_MANIFEST=$CR_MANIFEST_HERO
            BUILD_SYNC
            #BUILD_RECOVERY
            #BUILD_EXPORT
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
            CR_DEVICE=$CR_DEVICE_HERO2
            CR_SOURCE=$CR_SOURCE_HERO2
            CR_MANIFEST=$CR_MANIFEST_HERO2
            BUILD_SYNC
            #BUILD_RECOVERY
            #BUILD_EXPORT
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
