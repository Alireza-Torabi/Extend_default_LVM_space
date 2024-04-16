#!/bin/bash

# Prompt for sudo password at the beginning
sudo echo "Starting disk setup..."
sudo echo "befor do any thing create a partition from new disk added with 'cfdisk' App"
sudo echo "For example: 'cfdisk /dev/sdb'"

sudo echo "List of Disks and Partitions:"
lsblk

# Prompt user for physical volume path
read -p "Please select a partition that does not have any logical volumes in its subset. (e.g., /dev/sdb1): " pv_path
# Create physical volume
sudo pvcreate "$pv_path"


# Prompt user for volume group name
read -p "Enter volume group name (e.g., my_vg): " vg_name

# Create volume group
sudo vgcreate "$vg_name" "$pv_path"


# Prompt user for logical volume name
read -p "Enter logical volume name (e.g., lv_data): " lv_name

# Create logical volume
sudo lvcreate -l 100%FREE -n "$lv_name" "$vg_name"

lvdisplay
# Prompt user for logical volume path for formatting
read -p "Enter logical volume path for format (e.g., /dev/my_vg/lv_data): " lv_path


# Quick format logical volume with ext4 filesystem
mkfs.ext4 -F -E nodiscard "$lv_path"

# Prompt user for mount path
read -p "Enter mount path for the logical volume (e.g., /mnt/data): " mount_path

# Mount the logical volume to the specified path
sudo mkdir -p "$mount_path"
sudo mount "$lv_path" "$mount_path"

# Update /etc/fstab to auto-mount the logical volume at boot
echo "$lv_path $mount_path ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null

echo "Disk setup completed."

# Ask user if they want to reboot the system
read -p "Do you want to reboot the system now? (yes/no): " reboot_option

if [[ "$reboot_option" == "yes" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "You chose not to reboot the system. Please remember to reboot later for the changes to take effect."
fi
