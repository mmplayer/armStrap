# Usage: buildRoot
function buildRoot {
  printStatus "buildRoot" "Starting"

  bootStrap "${BUILD_MNT_ROOT}" "${BUILD_ARCH}" "${BUILD_ARCH_EABI}" "${BUILD_DEBIAN_SUITE}"

  setHostName "${BUILD_MNT_ROOT}" "${ARMSTRAP_HOSTNAME}"
  
  clearSourcesList "${BUILD_MNT_ROOT}"
  addSource "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_SOURCE}" "${BUILD_DEBIAN_SUITE}" ${BUILD_DEBIAN_SOURCE_COMPONENTS}
  addSource "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_SOURCE}" "${BUILD_DEBIAN_SUITE}-updates" ${BUILD_DEBIAN_SOURCE_COMPONENTS}
  addSource "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_SOURCE_SECURITY}" "${BUILD_DEBIAN_SUITE}/updates" ${BUILD_DEBIAN_SOURCE_SECURITY_COMPONENTS}

  initSources "${BUILD_MNT_ROOT}"
  
  if [ -n "${BUILD_DEBIAN_EXTRAPACKAGES}" ]; then
    if [ -n "${ARMSTRAP_SWAP}" ]; then
      installPackages "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_EXTRAPACKAGES} dphys-swapfile"
      printf "CONF_SWAPSIZE=%s" "${ARMSTRAP_SWAP_SIZE}" > "${BUILD_MNT_ROOT}/etc/dphys-swapfile"
    else
      installPackages "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_EXTRAPACKAGES}"
    fi
  fi

  configPackages "${BUILD_MNT_ROOT}" "${BUILD_DEBIAN_RECONFIG}"
  
  if [ -d "${ARMSTRAP_ROOT}/boards/${ARMSTRAP_CONFIG}/dpkg" ]; then
    for i in "${ARMSTRAP_ROOT}/boards/${ARMSTRAP_CONFIG}/dpkg/*.deb"; do
      installDPKG "${BUILD_MNT_ROOT}" ${i}
    done
  fi

  setRootPassword "${BUILD_MNT_ROOT}" "${ARMSTRAP_PASSWORD}"
  
  addInitTab "${BUILD_MNT_ROOT}" "${BUILD_SERIALCON_ID}" "${BUILD_SERIALCON_RUNLEVEL}" "${BUILD_SERIALCON_TERM}" "${BUILD_SERIALCON_SPEED}" "${BUILD_SERIALCON_TYPE}"

  initFSTab "${BUILD_MNT_ROOT}" 
  addFSTab "${BUILD_MNT_ROOT}" "${BUILD_FSTAB_ROOTDEV}" "${BUILD_FSTAB_ROOTMNT}" "${BUILD_FSTAB_ROOTFST}" "${BUILD_FSTAB_ROOTOPT}" "${UILD_FSTAB_ROOTDMP}" "${BUILD_FSTAB_ROOTPSS}"

  for i in "${BUILD_KERNEL_MODULES}"; do
    addKernelModule "${BUILD_MNT_ROOT}" "${i}"
  done

  addIface "${BUILD_MNT_ROOT}" "eth0" "${ARMSTRAP_ETH0_MODE}" "${ARMSTRAP_ETH0_IP}" "${ARMSTRAP_ETH0_MASK}" "${ARMSTRAP_ETH0_GW}"
  
  if [ "${ARMSTRAP_ETH0_MODE}" != "dhcp" ]; then
    initResolvConf "${BUILD_MNT_ROOT}" 
    addSearchDomain "${BUILD_MNT_ROOT}" "${ARMSTRAP_ETH0_DOMAIN}"
    addNameServer "${BUILD_MNT_ROOT}" "${ARMSTRAP_ETH0_DNS}"
  fi
  
  bootClean "${BUILD_MNT_ROOT}" "${BUILD_ARCH}"
  
  printStatus "buildRoot" "Done"

}
