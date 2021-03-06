# Usage: buildBoot

function buildBoot {
  printStatus "buildBoot" "Starting"
  
  gitSources ${BUILD_UBOOT_GIT} ${BUILD_UBOOT_DIR}
  gitSources ${BUILD_SUNXI_BOARD_GIT} ${BUILD_SUNXI_BOARD_DIR}
  gitSources ${BUILD_SUNXI_TOOLS_GIT} ${BUILD_SUNXI_TOOLS_DIR}

  sunxiMkTools ${BUILD_SUNXI_TOOLS_DIR}
  
  sunxiMkUBoot ${BUILD_UBOOT_DIR}

  ubootSetEnv "${BUILD_BOOT_CMD}" "bootargs" "${BUILD_CONFIG_CMDLINE}"
  ubootExt2Load "${BUILD_BOOT_CMD}" "${BUILD_BOOT_BIN_LOAD}"
  ubootExt2Load "${BUILD_BOOT_CMD}" "${BUILD_BOOT_KERNEL_LOAD}"
  ubootBootM "${BUILD_BOOT_CMD}" "${BUILD_BOOT_KERNEL_ADDR}"

  sunxiMkImage ${BUILD_BOOT_CMD} ${BUILD_BOOT_SCR}
  
  sunxiSetFex ${BUILD_SUNXI_BOARD_DIR} "${BUILD_BOARD_CPU}" "${BUILD_BOARD}" "${BUILD_MNT_BOOT}/"
  
  if [ "${ARMSTRAP_MAC_ADDRESS}" != "" ]; then
    sunxiSetMac "${BUILD_BOOT_FEX}" "${ARMSTRAP_MAC_ADDRESS}"
  fi

  sunxiFex2Bin ${BUILD_SUNXI_TOOLS_DIR} ${BUILD_BOOT_FEX} ${BUILD_BOOT_BIN}
  
  if [ -z ${ARMSTRAP_DEVICE} ]; then
    ubootDDLoader "${BUILD_BOOT_SPL}" "${ARMSTRAP_IMAGE_DEVICE}" "${BUILD_BOOT_SPL_SIZE}" "${BUILD_BOOT_SPL_SEEK}"
    ubootDDLoader "${BUILD_BOOT_UBOOT}" "${ARMSTRAP_IMAGE_DEVICE}" "${BUILD_BOOT_UBOOT_SIZE}" "${BUILD_BOOT_UBOOT_SEEK}"
  else
    ubootDDLoader "${BUILD_BOOT_SPL}" "${ARMSTRAP_DEVICE}" "${BUILD_BOOT_SPL_SIZE}" "${BUILD_BOOT_SPL_SEEK}"
    ubootDDLoader "${BUILD_BOOT_UBOOT}" "${ARMSTRAP_DEVICE}" "${BUILD_BOOT_UBOOT_SIZE}" "${BUILD_BOOT_UBOOT_SEEK}"
  fi
  
  gitExport ${BUILD_UBOOT_DIR} ${BUILD_UBOOT_SRCDST}
  gitExport ${BUILD_SUNXI_BOARD_DIR} ${BUILD_SUNXI_BOARD_SRCDST}
  gitExport ${BUILD_SUNXI_TOOLS_DIR} ${BUILD_SUNXI_TOOLS_SRCDST}
  
  printStatus "buildBoot" "Done"
}
