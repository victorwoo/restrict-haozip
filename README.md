# restrict-haozip

`restrict-haozip` 是一个开源项目，旨在通过多种方式限制或解除好压（HaoZip）及其附带服务的执行权限。此项目包含两个 PowerShell 脚本：`RestrictHaoZip.ps1` 和 `UnrestrictHaoZip.ps1`，分别用于设置和解除 HaoZip 的执行限制。

## 功能概述

- **RestrictHaoZip.ps1**：通过以下方式限制 HaoZip 相关进程和服务的执行权限：
  - **卸载应用**：卸载名为 `安全组件 - 2345` 的附加程序。
  - **删除服务**：删除 `2345SafeCenterSvc` 和 `2345HaoZip` 服务，确保 HaoZip 及其附带服务无法运行。
  - **结束进程**：终止 HaoZip 相关进程，包括 `HaoZipTool.exe`、`HaoZipHomePage.exe`、`HaoZipWorker.exe` 以及 Protect 目录中的所有进程。
  - **ACL 限制**：通过设置访问控制列表（ACL），限制 HaoZip 目录下相关文件的执行权限，进一步防止 HaoZip 运行。
  
- **UnrestrictHaoZip.ps1**：解除先前设置的执行限制，恢复 HaoZip 的正常权限，允许其重新运行。

## 使用说明

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

## 注意事项

- **管理员权限**：为了修改系统权限，脚本必须以管理员权限运行。
- **兼容性**：本项目适用于安装了 PowerShell 的 Windows 系统，建议使用 Windows 10 及以上版本。
- **测试环境**：请在测试环境中确认限制和解除效果，以确保不会影响正常使用。

## 贡献指南

欢迎对 `restrict-haozip` 项目进行贡献！如果您有改进建议、发现问题或希望新增功能，请提交 [Issue](https://github.com/victorwoo/restrict-haozip/issues) 或发起 [Pull Request](https://github.com/victorwoo/restrict-haozip/pulls)。

## 授权协议

本项目遵循 [MIT License](https://opensource.org/licenses/MIT)。您可以自由使用、修改和分发本项目代码，但请保留原始的版权声明。

---

感谢您的使用！希望 `restrict-haozip` 项目能帮助您更好地管理 HaoZip 的执行权限。