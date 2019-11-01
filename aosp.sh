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

# Main
CR_DIR=$(pwd)
CR_REPO=.repo/local_manifests
CR_ORG=https://github.com/Exynos5433
CR_BUILD=userdebug
CR_DRIVE= # Export before build.
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

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"
     make clean && make clobber
else
     echo "Dirty Build"
fi

# ROM Support
read -p "ROM? 
1- lineage-16 
2- ResurrectionRemix-Pie
3- AospExtended-Pie
4- Havoc-Pie > " rom
if [ "$rom" = "1" ]; then
     echo "Building LineageOS-16.0"
     CR_ROM_ID="1"
else
if [ "$rom" = "2" ]; then
     echo "Building Resurrection Remix Pie"
     CR_ROM_ID="2"
fi
if [ "$rom" = "3" ]; then
     echo "Building AospExtended Pie"
     CR_ROM_ID="3"
fi
if [ "$rom" = "4" ]; then
     echo "Building Havoc Pie"
     CR_ROM_ID="4"
fi
fi
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
    . build/envsetup.sh
    fi
    fi
}

BUILD_OUT()
{
    echo "----------------------------------------------"
    echo " "
    if [ "$CR_ROM_ID" = "1" ]; then
        CR_LUNCH=lineage
        CR_ROM=lineage-16.0
        CR_BRANCH=lineage-16.0
        OUT=$CR_DIR/out/target/product/$CR_SUB_DEVICE/$CR_ROM-$CR_DATE-UNOFFICIAL-$CR_SUB_DEVICE.zip
    else
    if [ "$CR_ROM_ID" = "2" ]; then
        CR_LUNCH=rr
        CR_ROM=RR-P-v7.0.2
        CR_BRANCH=lineage-16.0
        OUT=$CR_DIR/out/target/product/$CR_SUB_DEVICE/$CR_ROM-$CR_DATE-$CR_SUB_DEVICE-Unofficial.zip  
    fi
    if [ "$CR_ROM_ID" = "3" ]; then
        CR_LUNCH=aosp
        CR_ROM=AospExtended-v6.7
        CR_BRANCH=aex-pie
        OUT=$CR_DIR/out/target/product/$CR_SUB_DEVICE/$CR_ROM-$CR_SUB_DEVICE-'*'-$CR_DATE-UNOFFICIAL.zip  
    fi
    if [ "$CR_ROM_ID" = "4" ]; then
        CR_LUNCH=havoc
        CR_ROM=Havoc-OS-v2.9
        CR_BRANCH=havoc-pie
        OUT=$CR_DIR/out/target/product/$CR_SUB_DEVICE/$CR_ROM-$CR_DATE-$CR_SUB_DEVICE-Unofficial.zip  
    fi
    fi
    echo " Generate $CR_ROM out directory "
    echo " "
    echo " "
    echo " Target zip = $OUT"
}

BUILD_COMPILE()
{
    echo "----------------------------------------------"
    echo " "
    echo " Begin compiling $CR_SUB_DEVICE "
    lunch $CR_LUNCH'_'$CR_SUB_DEVICE'-'$CR_BUILD
    mka bacon -j$CR_JOBS
    if [ -e $OUT ]; then
    echo "$CR_SUB_DEVICE Build Success..."
    else
    if [ ! -e $OUT ]; then
    echo "$CR_SUB_DEVICE Build Failed..."
    exit 0;
    fi
    fi
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
    if [ -e $OUT ]; then
      echo " Uploading build to google drive "
      gdrive upload -p $CR_DRIVE $OUT
    else
    if [ ! -e $OUT ]; then
    echo "$CR_DEVICE Build not found"
    exit 0;
    fi
    fi
    echo " "
    echo "----------------------------------------------"
}

# Main Menu
PS3='Please select your option (1-6): '
menuvar=("treltexx" "trelteskt" "tre3calteskt" "tbelteskt" "tre" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "treltexx")
            clear
            echo "Starting treltexx build..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            CR_SUB_DEVICE=treltexx
            BUILD_OUT
            BUILD_SYNC
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "trelteskt")
            clear
            echo "Starting trelteskt build..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            CR_SUB_DEVICE=trelteskt
            BUILD_OUT
            BUILD_SYNC
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "tre3calteskt")
            clear
            echo "Starting tre3calteskt build..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            CR_SUB_DEVICE=tre3calteskt
            BUILD_OUT
            BUILD_SYNC
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "tbelteskt")
            clear
            echo "Starting tbelteskt build..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            CR_SUB_DEVICE=tbelteskt
            BUILD_OUT
            BUILD_SYNC
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "tre")
            clear
            echo "Starting Note4 builds..."
            CR_DEVICE=$CR_DEVICE_TRE
            CR_MANIFEST=$CR_MANIFEST_TRE
            BUILD_SYNC
            CR_SUB_DEVICE=treltexx
            echo "Compiling $CR_SUB_DEVICE"
            BUILD_OUT
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "----------------------------------------------"
            CR_SUB_DEVICE=trelteskt
            echo "Compiling $CR_SUB_DEVICE"
            BUILD_OUT
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "----------------------------------------------"
            CR_SUB_DEVICE=tre3calteskt
            echo "Compiling $CR_SUB_DEVICE"
            BUILD_OUT
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
            echo "----------------------------------------------"
            CR_SUB_DEVICE=tbelteskt
            echo "Compiling $CR_SUB_DEVICE"
            BUILD_OUT
            BUILD_COMPILE
            BUILD_UPLOAD
            echo " "
            echo "----------------------------------------------"
            echo "$CR_SUB_DEVICE build finished."
            echo "$CR_SUB_DEVICE Ready at $OUT"
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
