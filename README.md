![Static Badge](https://img.shields.io/badge/build-passing-green)
![Static Badge](https://img.shields.io/badge/version-0.1-blue)


# centos-mirror-switcher

centos-mirror-switcher.sh 专门为了Centos 脚本实现的脚本，用于解决Centos代码包支持问题，使用中文镜像地址作依赖地址

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

-   x86_32 脚本不支持(centos 很少见了)
- 支持 x86_64 centos 5/6/7/8 主流支持
- 其他平台altarch的：centos 6/7


## 项目依赖

- 依赖的镜像地址：https://mirrors.tuna.tsinghua.edu.cn/

## 进展

维护中

## 常见问题

**为什么不支持 x86_32平台**

Centos 现在已经很少见到这个包，关键是没有这个对应的依赖库

**为什么不支持的 Centos steam 系列**

CentOS Stream 9 需要手动来更新：https://mirrors.tuna.tsinghua.edu.cn/help/centos-stream/