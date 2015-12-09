#!/bin/bash

function install_packages() {
	local PACKAGES="";
	for PACKAGE in $(cat "$BASE_PATH/dnf-packages"); do
		PACKAGES+=" $PACKAGE";
	done;
	sudo dnf install $PACKAGES;
}

function install_home_files() {
	for FILE in $(ls -a $BASE_PATH/home-files); do
		
		if [ "$FILE" == "." ] || [ "$FILE" == ".." ]; then
			continue;
		fi;
	
		SOURCE_FILE="$(realpath $BASE_PATH/home-files/$FILE)";	
		TARGET_FILE="$HOME/$FILE";
		
		if [ ! -e "$TARGET_FILE" ]; then
			echo "Linking $SOURCE_FILE to $TARGET_FILE";
			ln -s "$SOURCE_FILE" "$TARGET_FILE";
		elif [ "$REPLACE_HOME_FILES" == "y" ]; then
			echo "Deleting $TARGET_FILE";
			rm "$TARGET_FILE";
			echo "Linking $SOURCE_FILE to $TARGET_FILE";
			ln -s "$SOURCE_FILE" "$TARGET_FILE";
		else
			echo "$TARGET_FILE exists...skipping";
		fi;
	
	done;
}

BASE_PATH="$(dirname $0)";

read -p "Perform a dnf update? (y/n): " DNF_UPDATE;
if [ "$DNF_UPDATE" == "y" ]; then
	sudo dnf update;
fi;

read -p "Install all the dnf packages? (y/n): " INSTALL_PACKAGES;
if [ "$INSTALL_PACKAGES" == "y" ]; then
	install_packages;
fi;

read -p "Setup the home config files? (y/n): " INSTALL_HOME_FILES;
if [ "$INSTALL_HOME_FILES" == "y" ]; then
	read -p "Replace existing config files? (y/n): " REPLACE_HOME_FILES;
	install_home_files;
fi;
