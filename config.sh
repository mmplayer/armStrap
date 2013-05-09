##############################################################################
# Build configuration
#
# Set this to the name of the board you want to build
BOARD_CONFIG="CubieBoard"
# Set this to the hostname you want for the board
BOARD_HOSTNAME="CubieDebian"
# Set this to the password you want for the root user
BOARD_PASSWORD="debian"

##############################################################################
# Swapfile configuration
#
# If you want a swapfile, uncomment this.
BOARD_SWAP="yes"
# If you want a fixed size swapfile, set this (in MB).
BOARD_SWAP_SIZE="256"

##############################################################################
# Network configuration
#
# If you want to use DHCP, use the following
BOARD_ETH0_MODE="dhcp"
# Or if you want a static IP use the following
#BOARD_ETH0_MODE="static"
#BOARD_ETH0_IP="192.168.0.100"
#BOARD_ETH0_MASK="255.255.255.0"
#BOARD_ETH0_GW="192.168.0.1"
#BOARD_DNS="8.8.8.8 8.8.4.4"
#BOARD_DOMAIN="localhost.com"
# Some board need a mac address, if this is not set and the board need one,
# a pseudo random mac address will be generated.
BOARD_MAC_ADDRESS="008010EDDF01"

##############################################################################
# Output configuration
#
# If you want to install directly into your SD card, put the device here
#BUILD_DEVICE="/dev/sdc"