#!/bin/bash
#
# AOSP Build Script V1.0
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
CR_ORG=https://github.com/Exynos5433
CR_BRANCH=lineage-16.0
# Thread count
CR_JOBS=$(nproc --all)
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export USE_CCACHE=1
##########################################
# Device specific Variables [SM-N91X]
CR_DEVICE_TRE=treltexx
CR_MANIFEST_TRE=treltexx.xml
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
        rm -rf $CR_DIR/device
    fi
    echo "Getting Device manifest."
    curl -OL https://raw.githubusercontent.com/$CR_ORG/local_manifests/$CR_BRANCH/$CR_DEVICE.xml
    if [ -e $CR_DIR/$CR_DEVICE.xml ]; then
        echo "Copying Manifest"
        mv $CR_DIR/$CR_DEVICE.xml $CR_DIR/$CR_REPO/$CR_DEVICE.xml
        echo "$CR_DEVICE Manifest cloned, Sync...."
    else
    if [ ! -e $CR_DIR/$CR_DEVICE.xml ]; then
    exit 0;
    echo "$CR_DEVICE Sync failed! Please check repos."
    fi
    fi
    # AOSP Repo Sync
    repo sync -c -j$CR_JOBS --force-sync -f --no-clone-bundle --no-tags
    if [ ! -e $CR_DIR/device/samsung/$CR_DEVICE ]; then
    exit 0;
    echo "$CR_DEVICE Sync failed! Please check repos."
    else
    if [ -e $CR_DIR/device/samsung/$CR_DEVICE ]; then
    echo "$CR_DEVICE Sync success! Building..."
    fi
    fi
}

BUILD_CLEAN()
{
    echo "----------------------------------------------"
    echo " "
    echo " Cleaning build folder "
    make clean
    echo " "
    echo "----------------------------------------------"
}

BUILD_COMPILE()
{
    echo "----------------------------------------------"
    echo " "
    echo " "
    echo "----------------------------------------------"
}
BUILD_EXPORT()
{
    echo "----------------------------------------------"
    echo " "
    echo " "
    echo "----------------------------------------------"
}
BUILD_UPLOAD()
{
    echo "----------------------------------------------"
    echo " "
    echo " "
    echo "----------------------------------------------"
}

# Main Menu
PS3='Please select your option (1-2): '
menuvar=("treltexx" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "treltexx")
            clear
            echo "Starting $CR_DEVICE kernel build..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            CR_SUB_DEVICE=treltexx
            BUILD_SYNC
            BUILD_CLEAN
            echo " "
            echo "----------------------------------------------"
            echo "$CR_DEVICE build finished."
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
