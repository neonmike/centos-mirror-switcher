Here is the polished English translation of your README:

---

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/neonmike/centos-mirror-switcher/main.yml)  
![GitHub Release](https://img.shields.io/github/v/release/neonmike/centos-mirror-switcher)

# CentOS Mirror Switcher

## Why?

Official CentOS repositories are no longer maintained for older versions, and third-party mirror support is inconsistent. This project collects and organizes multiple actively maintained mirror URLs to simplify repository configuration.

## Features

- One-click replacement of software repository URLs  
- Supports **x86_64**: CentOS 5 / 6 / 7 / 8 and CentOS Stream 9  
- Supports **ARM64 (aarch64)**: CentOS 6 / 7  

> ⚠️ **Note**: This tool does **not** support `debuginfo` packages—handling those is outside the scope of this project.

## Usage

**For users outside mainland China:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/neonmike/centos-mirror-switcher/main/centos-mirror-switcher.sh)
```

**For users in mainland China:**
```bash
bash <(curl -Ls https://cdn.jsdelivr.net/gh/neonmike/centos-mirror-switcher@main/centos-mirror-switcher.sh)
```

## Supported Platforms

- **x86_64**: CentOS 5, 6, 7, 8, and CentOS Stream 9  
- **ARM64**: CentOS 6, 7  

## Mirror Sources Used

- Tsinghua University: https://mirrors.tuna.tsinghua.edu.cn/  
- Alibaba Cloud: https://developer.aliyun.com/mirror/  
- Tencent Cloud: https://mirrors.tencent.com/  

## Project Progress

- ✅ Version 1: Initial implementation complete  
- ✅ Version 2: Optimizations and improvements complete  

## FAQ

**Q: Why isn’t x86_32 (i386) supported?**  
A: CentOS rarely provides i386 packages nowadays, and essential dependencies for those architectures are largely unavailable.

**Q: Why isn’t CentOS Stream 8 supported?**  
A: At the time of development, no reliable or complete mirror sources for CentOS Stream 8 were identified among the supported repositories.