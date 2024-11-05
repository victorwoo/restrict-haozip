# restrict-haozip

`restrict-haozip` 是一个开源项目，旨在通过设置 ACL 来限制或解除好压（HaoZip）及其附带服务的执行权限。此项目包含两个 PowerShell 脚本：`RestrictHaoZip.ps1` 和 `UnrestrictHaoZip.ps1`，分别用于设置和解除 HaoZip 的执行限制。

## 功能概述

- **RestrictHaoZip.ps1**：通过 ACL 设置限制 HaoZip 相关进程和 Protect 目录内文件的执行权限。
- **UnrestrictHaoZip.ps1**：解除先前设置的执行限制，恢复 HaoZip 的正常权限。

在项目的 [Releases](https://github.com/victorwoo/restrict-haozip/releases) 页面中，您可以下载已编译的可执行文件：

- `RestrictHaoZip.exe` - 控制台版本，用于限制 HaoZip 执行权限
- `RestrictHaoZipNoConsole.exe` - 图形界面版本（无控制台窗口），用于限制 HaoZip 执行权限
- `UnrestrictHaoZip.exe` - 控制台版本，用于解除 HaoZip 的执行限制
- `UnrestrictHaoZipNoConsole.exe` - 图形界面版本（无控制台窗口），用于解除 HaoZip 的执行限制

## 使用说明

### 下载并运行可执行文件

1. 前往项目的 [Releases 页面](https://github.com/victorwoo/restrict-haozip/releases) 下载所需的 `.exe` 文件。
2. 以管理员权限运行所下载的 `.exe` 文件，以确保具有足够权限执行 ACL 更改。

> **注意**：运行限制或解除限制操作前，请确保没有 HaoZip 的相关进程正在运行，以避免权限冲突。

### 使用 PowerShell 脚本

1. 克隆或下载此项目代码。
2. 在项目目录下，找到 `RestrictHaoZip.ps1` 和 `UnrestrictHaoZip.ps1`。
3. 使用 PowerShell 以管理员权限运行脚本：

   ```powershell
   # 限制执行权限
   .\RestrictHaoZip.ps1

   # 解除执行限制
   .\UnrestrictHaoZip.ps1
   ```

> **警告**：为确保权限更改生效，建议在执行这些脚本前关闭所有 HaoZip 的相关进程。

## 构建说明

要构建可执行文件，您可以使用以下工具将 `.ps1` 脚本打包为 `.exe`：

## 注意事项

- **管理员权限**：为了修改系统权限，脚本和可执行文件必须以管理员权限运行。
- **兼容性**：本项目适用于安装了 PowerShell 的 Windows 系统，建议使用 Windows 10 及以上版本。
- **测试环境**：请在测试环境中确认限制和解除效果，以确保不会影响正常使用。

## 贡献指南

欢迎对 `restrict-haozip` 项目进行贡献！如果您有改进建议、发现问题或希望新增功能，请提交 [Issue](https://github.com/victorwoo/restrict-haozip/issues) 或发起 [Pull Request](https://github.com/victorwoo/restrict-haozip/pulls)。

## 授权协议

本项目遵循 [MIT License](https://opensource.org/licenses/MIT)。您可以自由使用、修改和分发本项目代码，但请保留原始的版权声明。

---

感谢您的使用！希望 `restrict-haozip` 项目能帮助您更好地管理 HaoZip 的执行权限。
