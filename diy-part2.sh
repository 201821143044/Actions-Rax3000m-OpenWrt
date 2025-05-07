#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,xray-plugin,v2ray-core,v2ray-plugin,v2ray-geodata,sing-box,hysteria,naiveproxy,shadowsocks-rust,tuic-client,microsocks,chinadns-ng,alist,dns2socks,dns2tcp,ipt2socks}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-ssr-plus}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld

# 更新 golang 1.24 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 添加luci-app-alist源码
git clone https://github.com/sbwml/luci-app-alist package/alist

# 替换最新版brook
rm -rf feeds/packages/net/brook
git clone -b main https://github.com/xiaorouji/openwrt-passwall-packages.git
cp -r openwrt-passwall-packages/brook feeds/packages/net
rm -rf openwrt-passwall-packages

# 克隆 coolsnowwolf 的 luci 和 packages 仓库
git clone https://github.com/coolsnowwolf/luci.git coolsnowwolf-luci
git clone https://github.com/coolsnowwolf/packages.git coolsnowwolf-packages

# 替换luci-app-zerotier和luci-app-frpc
rm -rf feeds/luci/applications/{luci-app-zerotier,luci-app-frpc}
cp -r coolsnowwolf-luci/applications/{luci-app-zerotier,luci-app-frpc} feeds/luci/applications
cp coolsnowwolf-luci/luci.mk package/
sed -i 's|include ../../luci\.mk|include ../../../../package/luci.mk|' feeds/luci/applications/luci-app-zerotier/Makefile
sed -i 's|include ../../luci\.mk|include ../../../../package/luci.mk|' feeds/luci/applications/luci-app-frpc/Makefile

# 替换zerotier、frp 和kcptun
rm -rf feeds/packages/net/{zerotier,frp,kcptun,haproxy}
cp -r coolsnowwolf-packages/net/{zerotier,frp,kcptun,haproxy} feeds/packages/net

# 修改frp版本为官网最新v0.62.1 https://github.com/fatedier/frp
rm -rf feeds/packages/net/frp
wget https://github.com/coolsnowwolf/packages/archive/0f7be9fc93d68986c179829d8199824d3183eb60.zip -O OldPackages.zip
unzip OldPackages.zip
cp -r packages-0f7be9fc93d68986c179829d8199824d3183eb60/net/frp feeds/packages/net/
rm -rf OldPackages.zip packages-0f7be9fc93d68986c179829d8199824d3183eb60s
sed -i 's/PKG_VERSION:=0.53.2/PKG_VERSION:=0.62.1/' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=ff2a4f04e7732bc77730304e48f97fdd062be2b142ae34c518ab9b9d7a3b32ec/PKG_HASH:=d0513f1c08f7a6b31f91ddeca64ccdec43726c20d20103de5220055daa04b903/' feeds/packages/net/frp/Makefile

# 删除克隆的 coolsnowwolf-luci 和 coolsnowwolf-packages 仓库
rm -rf coolsnowwolf-luci
rm -rf coolsnowwolf-packages

git clone https://github.com/coolsnowwolf/lede.git coolsnowwolf-lede
cp -r coolsnowwolf-lede/package/lean/upx package/
rm -rf coolsnowwolf-lede
