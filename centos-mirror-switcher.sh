#!/bin/bash
#    Copyright 2025 CCK

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
set -e          #遇到错误就退出
PS4='+$LINENO:' #行号

os_name="UnknownOS"
os_version="UnknownVersion"
os_plat=$(uname -m)

if [ "$(id -u)" -ne 0 ]; then
	echo "Please switch to root to run the script."
	exit 1
fi

sys_check() {
	if [ -e /etc/os-release ]; then
		. /etc/os-release # 读取系统发行版信息
		os_name=${ID}
		os_version=${VERSION_ID}
	elif [ -e /etc/redhat-release ]; then
		result=$(sed -r 's/^(CentOS).*release ([0-9]+).*/\1 \2/' /etc/redhat-release)
		os_name=${result%% *}    # 第一个空格前的部分
		os_version=${result##* } # 最后一个空格后的部分
	fi
	# 权限检查：确保用户是 root 或具有 sudo 权限
	if [[ "$os_name" == "UnknownOS" || "$os_version" == "UnknownVersion" ]]; then
		echo "Unknown OS detected: os_name=$os_name, os_version=$os_version. Script exiting with status 1."
		exit 1
	fi

	echo "System platform:$os_plat,SystemOS:$os_name,SystemVersion:$os_version."
}

set_stream9() {
	mirrors="https://mirrors.tuna.tsinghua.edu.cn/centos-stream"
	if [ $# -lt 1 ]; then
		echo "Usage: $0 <filename1> <filename2> ..." >&2
		exit 1
	fi
	for filename in "$@"; do
		backup_filename="${filename}.bak"
		mv "$filename" "$backup_filename"

		# 创建新文件
		>"$filename"

		while IFS= read -r line; do
			# 注释掉 metalink 开头的行
			if [[ "$line" =~ ^metalink ]]; then
				echo "# $line" >>"$filename"
				continue
			fi

			# 如果是 name 行，追加 baseurl
			if [[ "$line" =~ ^name ]]; then
				# 拆分 name-xxx-arch
				IFS="-" read -r _ repo arch <<<"$line"

				repo=$(echo "$repo" | xargs) # 去空格
				arch=$(echo "${arch:-}" | tr '[:upper:]' '[:lower:]' | xargs)

				if [[ "$repo" =~ ^Extras ]]; then
					if [[ "$arch" == "source" ]]; then
						line="$line"$'\n'"baseurl=${mirrors}/SIGs/\$releasever-stream/extras/${arch}/extras-common"
					else
						line="$line"$'\n'"baseurl=${mirrors}/SIGs/\$releasever-stream/extras/\$basearch/extras-common"
					fi
				else
					if [[ "$arch" == "source" ]]; then
						line="$line"$'\n'"baseurl=${mirrors}/\$releasever-stream/${repo}/"
					elif [[ -n "$arch" ]]; then
						line="$line"$'\n'"baseurl=${mirrors}/\$releasever-stream/${repo}/\$basearch/${arch}/tree/"
					else
						line="$line"$'\n'"baseurl=${mirrors}/\$releasever-stream/${repo}/\$basearch/os"
					fi
				fi
			fi
			echo "$line" >>"$filename"
		done <"$backup_filename"
	done

}
# 提供对其他平台的源地址更新
update_centos_othplat() {
	if [[ "$1" == "centos" && "$2" == "8" ]]; then
		sed -e "s|^mirrorlist=|#mirrorlist=|g" \
			-e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/8.5.2111|g" \
			-e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/8.5.2111|g" \
			-i.bak \
			/etc/yum.repos.d/CentOS-*.repo
	elif [[ "$1" == "centos" && "$2" == "7" ]]; then
		cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
		curl -fSL -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-altarch-7.repo
	else
		echo " update centos failed ,Centos $1 ,version : $2 "
		exit 1
	fi
}

update_centos_x86() {
	if [[ "$1" == "centos" && "$2" == "7" ]]; then
		sed -e "s|^mirrorlist=|#mirrorlist=|g" \
			-e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
			-e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
			-i.bak \
			/etc/yum.repos.d/CentOS-*.repo
	elif [[ "$1" == "centos" && "$2" == "8" ]]; then
		# CentOS 8
		sed -e "s|^mirrorlist=|#mirrorlist=|g" \
			-e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/8.5.2111|g" \
			-e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/8.5.2111|g" \
			-i.bak \
			/etc/yum.repos.d/CentOS-*.repo
	elif [[ "$1" == "CentOS" && "$2" == "6" ]]; then
		#  Centos 6
		sed -e "s|^mirrorlist=|#mirrorlist=|g" \
			-e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.10|g" \
			-e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.10|g" \
			-i.bak \
			/etc/yum.repos.d/CentOS-*.repo
	elif [[ "$1" == "CentOS" && "$2" == "5" ]]; then
		sed -e "s|^mirrorlist=|#mirrorlist=|g" \
			-e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos-vault/5.11|g" \
			-e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos-vault/5.11|g" \
			-i.bak \
			/etc/yum.repos.d/CentOS-*.repo /etc/yum.repos.d/libselinux.repo
	elif [[ "$1" == "centos" && "$2" == "9" ]]; then
		set_stream9 /etc/yum.repos.d/centos*.repo
	else
		echo "only support x86_64 centos 5/6/7/8 and centos stream 9 version , fail to udpate centos software source."
		exit 1
	fi
}

update_centos() {
	if [[ "$1" == "x86_64" ]]; then
		update_centos_x86 "$2" "$3"
	else
		update_centos_othplat "$2" "$3"
	fi
}

sys_check

update_centos "$os_plat" "$os_name" "$os_version"

yum makecache

echo "The CentOS software repository has been successfully updated."
