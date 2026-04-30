#!/bin/bash

# 让内核编译时手动指定LOCALVERSION版本, 避免headers与images版本不一致
scripts/config -d CONFIG_LOCALVERSION_AUTO
scripts/config --set-str CONFIG_LOCALVERSION '-cachyos'

# Do not change the system's hostname
scripts/config -u CONFIG_DEFAULT_HOSTNAME

# 开启CachyOS BORE用户态调度
scripts/config -e CONFIG_CACHY -e CONFIG_SCHED_BORE

# 开启必需的内核LSM模块
scripts/config --set-str CONFIG_LSM lockdown,yama,integrity,selinux,bpf,landlock,apparmor

# 设置内核中断定时器频率
# 开启硬件级高精度定时器
scripts/config -e CONFIG_HIGH_RES_TIMERS
# 当 CPU 空闲时，关闭周期性时钟中断
# 因此先关闭CachyOS内核配置里默认开着的CONFIG_NO_HZ_FULL等冲突选项
# 避免过于频繁地关闭CPU时钟中断导致日用卡顿
scripts/config -d CONFIG_HZ_PERIODIC
scripts/config -d CONFIG_NO_HZ_FULL
scripts/config -e CONFIG_NO_HZ_IDLE
scripts/config -d CONFIG_HZ_300
scripts/config -e CONFIG_HZ_500 --set-val HZ 500

# 启用安全启动相关支持
scripts/config -e CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
scripts/config -e CONFIG_IMA
scripts/config -e CONFIG_IMA_APPRAISE_BOOTPARAM
scripts/config -e CONFIG_IMA_APPRAISE
scripts/config -e CONFIG_IMA_ARCH_POLICY
scripts/config -e CONFIG_MODULE_SIG
scripts/config -e CONFIG_MODULE_SIG_ALL
scripts/config -e CONFIG_MODULE_SIG_SHA256
scripts/config -e CONFIG_SYSTEM_TRUSTED_KEYRING
scripts/config -e CONFIG_KEXEC_SIG

# 设置x86_64处理器ISA等级
scripts/config --set-val CONFIG_X86_64_VERSION 4

# 开启Clang Full-LTO支持
scripts/config -d CONFIG_LTO_NONE
scripts/config -d CONFIG_LTO_CLANG_THIN
scripts/config -e CONFIG_LTO_CLANG_FULL

# 开启PREEMPT_LAZY动态抢占支持
scripts/config -e CONFIG_PREEMPT_BUILD
scripts/config -e CONFIG_ARCH_HAS_PREEMPT_LAZY
scripts/config -d CONFIG_PREEMPT
scripts/config -d CONFIG_PREEMPT_VOLUNTARY
scripts/config -d CONFIG_PREEMPT_RT
scripts/config -e CONFIG_PREEMPT_LAZY

# 启用编译器O3编译选项支持
scripts/config -d CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
scripts/config -e CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3

# 调整OverlayFS设置适应磐石结构
scripts/config -d CONFIG_OVERLAY_FS_REDIRECT_DIR
scripts/config -e CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
scripts/config -d CONFIG_OVERLAY_FS_INDEX
scripts/config -e CONFIG_OVERLAY_FS_XINO_AUTO
scripts/config -d CONFIG_OVERLAY_FS_METACOPY
scripts/config -d CONFIG_OVERLAY_FS_DEBUG
