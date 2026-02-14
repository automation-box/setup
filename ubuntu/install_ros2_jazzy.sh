#!/usr/bin/env bash

# Exit immediately if a command exits with a non‑zero status
set -e

echo "Updating package lists"
sudo apt update

# Setting locale to UTF-8 (if not already configured)
echo "Setting locale to UTF-8"
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Install software-properties-common and curl for repository management
echo "Installing required tools and enabling Universe repo"
sudo apt install -y software-properties-common curl
sudo add-apt-repository universe

# Update package lists after enabling the repository
echo "Updating package lists again"
sudo apt update

# Fetch the latest ROS2 apt source package version
echo "Fetching latest ROS2 apt source package version"
ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest \
  | grep -F "tag_name" \
  | awk -F\" '{print $4}')

# Download ROS2 apt source for the correct Ubuntu release
echo "Downloading ROS2 apt source for this Ubuntu release"
curl -L -o /tmp/ros2-apt-source.deb \
  "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME})_all.deb"

# Install ROS2 repository configuration
echo "Installing ROS2 repository configuration"
sudo dpkg -i /tmp/ros2-apt-source.deb

# Update the package list again after adding ROS2 repositories
echo "Updating package lists after ROS repo"
sudo apt update

# Upgrade existing packages
echo "Upgrading existing packages"
sudo apt upgrade -y

# Install ROS2 Jazzy Desktop version
echo "Installing ROS2 Jazzy Desktop (recommended)"
sudo apt install -y ros-jazzy-desktop

# Optional: Install ROS2 development tools
echo "Optional: Installing ROS2 development tools"
sudo apt install -y ros-dev-tools

# Add ROS2 setup script to ~/.bashrc to source it automatically on shell startup
echo "Adding ROS2 setup script to ~/.bashrc"
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

# Add environment variables to ~/.bashrc
echo "Adding ROS_DOMAIN_ID and other environment variables to ~/.bashrc"
echo "export ROS_DOMAIN_ID=1" >> ~/.bashrc
echo "export ROS_VERSION=2" >> ~/.bashrc
echo "export ROS_PYTHON_VERSION=3" >> ~/.bashrc
echo "export ROS_DISTRO=jazzy" >> ~/.bashrc

# Source the ROS setup file for the current session
source /opt/ros/jazzy/setup.bash

# Inform the user that the installation is complete
echo "Installation complete."
echo "To use ROS2 in every new shell, restart your terminal or run:"
echo "  source /opt/ros/jazzy/setup.bash"
echo "ROS_DOMAIN_ID has been set to 1. Modify this if needed for your network."

# Verify environment variables (ROS setup check)
echo "Verifying ROS environment variables..."
printenv | grep -i ROS

# Launch ROS nodes in separate terminal tabs
echo "Launching ROS nodes in separate terminal tabs..."
gnome-terminal --tab -- bash -c "ros2 run demo_nodes_cpp talker; exec bash" \
               --tab -- bash -c "ros2 run demo_nodes_py listener; exec bash"

