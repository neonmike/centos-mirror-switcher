![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/neonmike/centos-mirror-switcher/main.yml)
![GitHub Release](https://img.shields.io/github/v/release/neonmike/centos-mirror-switcher)

# centos-mirror-switcher

## why ?

Centos 版本没有官方包，各个镜像支持相对不太完善，整理和收集多个还在支持的镜像地址。

## 脚本功能

一键直接修改软件园地址

支持 x86_64  5/6/7/8 和 stream 9

支持 arm64 6/7

> 注意⚠️：不支持这一类debuginfo相关包，这不是这个项目的目的

## 使用方法

**海外用户**

```bash
bash <(curl -sL https://raw.githubusercontent.com/neonmike/centos-mirror-switcher/main/centos-mirror-switcher.sh)
```
**国内用户**
```bash
bash <(curl -Ls https://cdn.jsdelivr.net/gh/neonmike/centos-mirror-switcher@main/centos-mirror-switcher.sh) 
```


## 脚本支持

x86_64: Centos 5/6/7/8 和 stream 9
arm64: Centos 6/7

## 项目依赖

- 依赖的镜像地址：

    清华：https://mirrors.tuna.tsinghua.edu.cn/

    阿里：https://developer.aliyun.com/mirror/

    腾讯：https://mirrors.tencent.com/

## 进展

第一版本构建完成 

第二版本优化完成

## 常见问题

**为什么不支持 x86_32平台 ？**

Centos 现在已经很少见到这个包，关键是没有这个对应的依赖库

**为什么不支持的 Centos steam 8 ？**

CentOS Stream 8 没有发现依赖镜像地址
