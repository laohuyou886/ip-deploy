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

## CDN/镜像加速下载（推荐）

默认会**优先使用 CDN 镜像**下载（失败自动回落到 GitHub raw / ghproxy）。

- 关闭 CDN（强制 raw 优先）：

**Windows (PowerShell):**
```powershell
$env:IP_COLLECTOR_USE_CDN = "0"
irm https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.ps1 | iex
```

**Windows (BAT):**
```batch
set IP_COLLECTOR_USE_CDN=0
curl -fsSL https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.bat -o %TEMP%\run_ip-collector.bat && %TEMP%\run_ip-collector.bat
```

**Linux (Bash):**
```bash
export IP_COLLECTOR_USE_CDN=0
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
run_ip-collector.ps1 --quick --upload http://127.0.0.1:8080/upload
```

**BAT:**
```batch
run_ip-collector.bat --quick --upload http://127.0.0.1:8080/upload
```

**Bash:**
```bash
./run_ip-collector.sh --quick --upload http://127.0.0.1:8080/upload
```

默认建议先用 HTTP 本地联调：`http://<server-ip>:8080/upload`。
若你改为自签名 HTTPS，客户端请设置 `IPCOLLECTOR_TLS_INSECURE=1`。

## 局域网测试：Ubuntu 客户端上传到你的机器（10.10.89.113）

假设你在 **10.10.89.113** 上运行 `web-viewer`（默认监听 `0.0.0.0:8080`），上传接口为 `/upload`，那么在局域网另一台 Ubuntu 上直接跑：

```bash
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.sh | bash -s -- --quick --upload http://10.10.89.113:8080/upload
```

如果你的服务端启用了 `IPCOLLECTOR_TAKEN_KEY`，客户端需要同样设置：

```bash
export IPCOLLECTOR_TAKEN_KEY="你的key"
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/laohuyou886/ip-deploy/main/run_ip-collector.sh | bash -s -- --quick --upload http://10.10.89.113:8080/upload
```

## 说明

本仓库直接存放编译好的二进制文件：
- `bin/windows/ip-collector.exe` - Windows 版本
- `bin/linux/ip-collector` - Linux 版本

更新版本只需覆盖重新推送即可。
