#!/bin/bash

# Display current logical volume information
echo "Logical volume information before extending:"
lvdisplay
# Prompt user for LV Path.
read -p "Enter the LV Path you want to extend (e.g., /dev/ubuntu-vg/ubuntu-lv): " lv_path

# Extend logical volume
lvextend -l +100%FREE $lv_path

# Display current disk space usage
echo "Current disk space usage:"
df -h

# Prompt user for LV Filesystem path
read -p "Enter the Filesystem path you want to extend (e.g., /): " filesystem_path

# Resize filesystem
resize2fs $lv_path

# Display filesystem and logical volum information after resize
echo "Filesystem and logical volumn iformation after resizing:"
df -h
lvdisplay

