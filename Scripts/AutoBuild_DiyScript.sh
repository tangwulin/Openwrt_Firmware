#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions>
# AutoBuild DiyScript

Firmware_Diy_Core() {

	Author="广东千岩信息集团"
	Author_URL=AUTO
	Default_FLAG=AUTO
	Default_IP="192.168.1.1"
	Banner_Message="Powered by AutoBuild-Actions"

	Short_Firmware_Date=false
	Checkout_Virtual_Images=false
	Firmware_Format=AUTO
	REGEX_Skip_Checkout="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory"

	INCLUDE_AutoBuild_Features=true
	INCLUDE_Original_OpenWrt_Compatible=false
}

Firmware_Diy() {

	# 请在该函数内定制固件

	# 可用预设变量, 其他可用变量请参考运行日志
	# ${OP_AUTHOR}			OpenWrt 源码作者
	# ${OP_REPO}			OpenWrt 仓库名称
	# ${OP_BRANCH}			OpenWrt 源码分支
	# ${TARGET_PROFILE}		设备名称
	# ${TARGET_BOARD}		设备架构
	# ${TARGET_FLAG}		固件名称后缀

	# ${Home}				OpenWrt 源码位置
	# ${CONFIG_FILE}		使用的配置文件名称
	# ${FEEDS_CONF}			OpenWrt 源码目录下的 feeds.conf.default 文件
	# ${CustomFiles}		仓库中的 /CustomFiles 绝对路径
	# ${Scripts}			仓库中的 /Scripts 绝对路径
	# ${FEEDS_LUCI}			OpenWrt 源码目录下的 package/feeds/luci 目录
	# ${FEEDS_PKG}			OpenWrt 源码目录下的 package/feeds/packages 目录
	# ${BASE_FILES}			OpenWrt 源码目录下的 package/base-files/files 目录

	case "${OP_Maintainer}/${OP_REPO_NAME}:${OP_BRANCH}" in
	coolsnowwolf/lede:master)
		sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${feeds_pkgs}/ttyd/files/ttyd.config
		sed -i "/DEVICE_COMPAT_VERSION := 1.1/d" target/linux/ramips/image/mt7621.mk
	;;
	esac

	case "${TARGET_PROFILE}" in
	d-team_newifi-d2)
		patch -i ${CustomFiles}/d-team_newifi-d2_mac80211.patch package/kernel/mac80211/files/lib/wifi/mac80211.sh
		Copy ${CustomFiles}/d-team_newifi-d2_system ${base_files}/etc/config system
	;;
	esac
	case "${OP_Maintainer}/${OP_REPO_NAME}:${OP_BRANCH}" in
coolsnowwolf/lede:master)
	AddPackage git other AutoBuild-Packages Hyy2001X master
	AddPackage svn other luci-app-smartdns kenzok8/openwrt-packages/trunk
	AddPackage svn other luci-app-socat Lienol/openwrt-package/trunk
	AddPackage svn other luci-app-eqos kenzok8/openwrt-packages/trunk
	AddPackage git other OpenClash vernesong master
	AddPackage git other luci-app-adblock-plus small-5 master
	AddPackage git other small kenzok8 master
	AddPackage git other openwrt-packages kenzok8 master
	# AddPackage git other OpenAppFilter destan19 master
	# AddPackage svn other luci-app-ddnsto linkease/nas-packages/trunk/luci
	# AddPackage svn other ddnsto linkease/nas-packages/trunk/network/services
	
	case "${TARGET_PROFILE}" in
	asus_rt-acrh17 | d-team_newifi-d2 | xiaoyu_xy-c5)
		AddPackage git other luci-app-usb3disable rufengsuixing master
	;;
	x86_64)
		AddPackage git other openwrt-passwall xiaorouji main
		rm -rf packages/lean/autocore
		AddPackage git lean autocore-modify Hyy2001X master
	;;
	esac
;;
esac
}
