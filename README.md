# IP Deploy

IP Collector 一键部署工具

## 简介

目标机器无需任何依赖，只需一行命令即可自动下载运行最新版本。

## 使用方式

**Windows (PowerShell - 推荐):**
```powershell
irm https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.ps1 | iex
```

**Windows (批处理 - 兼容老系统):**
```batch
curl -fsSL https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.bat -o %TEMP%\run_ip-collector.bat && %TEMP%\run_ip-collector.bat
```

**Linux (Bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.sh | bash
```

## 自定义下载地址

**Windows (PowerShell):**
```powershell
$env:IP_COLLECTOR_RELEASE_URL = "https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows"
irm https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.ps1 | iex
```

**Windows (批处理):**
```batch
set IP_COLLECTOR_RELEASE_URL=https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/windows
curl -fsSL https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.bat -o %TEMP%\run_ip-collector.bat && %TEMP%\run_ip-collector.bat
```

**Linux (Bash):**
```bash
export IP_COLLECTOR_RELEASE_URL="https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/bin/linux"
curl -fsSL https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.sh | bash
```

## 优势

- ✅ **真正一行命令** - 目标机器无需任何依赖
- ✅ **多格式支持** - PowerShell 和批处理双版本支持
- ✅ **完全内网** - 使用 Gitea 内网服务，安全快速
- ✅ **自动更新** - 每次运行自动获取最新版本
- ✅ **跨平台支持** - 同时支持 Windows 和 Linux

## 参数透传（已支持）

三个启动脚本都会把你传入的参数原样透传给 `ip-collector`。  
例如你希望客户直接上传到服务端：

**PowerShell:**
```powershell
irm https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.ps1 | iex
# 然后执行：
run_ip-collector.ps1 --quick --upload https://127.0.0.1:8899/upload
```

**BAT:**
```batch
run_ip-collector.bat --quick --upload https://127.0.0.1:8899/upload
```

**Bash:**
```bash
./run_ip-collector.sh --quick --upload https://127.0.0.1:8899/upload
```

> 对自签名 HTTPS，客户端请设置 `IPCOLLECTOR_TLS_INSECURE=1`。

## 说明

本仓库直接存放编译好的二进制文件：
- `bin/windows/ip-collector.exe` - Windows 版本
- `bin/linux/ip-collector` - Linux 版本

更新版本只需覆盖重新推送即可。
