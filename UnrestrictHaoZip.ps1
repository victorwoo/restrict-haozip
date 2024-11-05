# UnrestrictHaoZip.ps1
# Requires PowerShell to be run as Administrator
# This script retrieves the HaoZip installation directory and removes execution restrictions
# on specific HaoZip executables and files within the "Protect" directory.

#requires -RunAsAdministrator

# Define a log function for standardized output without returning a value
function Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp - $Message" | Out-Host
}

# Step 1: Retrieve installation path
function Get-HaoZipPath {
    Write-Log "Starting Step 1: Retrieving installation path for 好压 - 2345"
    $appName = "好压 - 2345"
    $uninstallPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $haoZipUninstallString = (Get-ItemProperty -Path $uninstallPaths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq $appName }).UninstallString
    if ($haoZipUninstallString) {
        $haoZipPath = Split-Path -Path $haoZipUninstallString -Parent
        Write-Log "Step 1 completed: HaoZip installation path retrieved successfully - $haoZipPath"
        return $haoZipPath
    } else {
        Write-Log "Step 1 notice: 好压 - 2345 not found in the specified paths. Exiting."
        exit
    }
}

# Step 2: Remove ACL execution restriction
function Remove-ExecutionRestriction {
    param (
        [string[]]$PathsToUnrestrict
    )
    Write-Log "Starting Step 2: Removing ACL execution restrictions on specified paths."

    foreach ($path in $PathsToUnrestrict) {
        if (Test-Path -Path $path) {
            try {
                $acl = Get-Acl -Path $path
                $aclAccessRules = $acl.Access | Where-Object { 
                    $_.FileSystemRights -eq "ExecuteFile" -and $_.AccessControlType -eq "Deny" -and $_.IdentityReference -eq "Everyone" 
                }
                
                # Remove any deny execute rules for "Everyone"
                foreach ($rule in $aclAccessRules) {
                    $acl.RemoveAccessRule($rule) | Out-Null
                }
                
                Set-Acl -Path $path -AclObject $acl
                Write-Log "Execution permission restriction removed for $path"
            } catch {
                Write-Log "Failed: Could not remove execution restriction for $path."
            }
        } else {
            Write-Log "Notice: Path $path does not exist. Skipping ACL removal."
        }
    }
}

# Main execution
$haoZipPath = Get-HaoZipPath

# Define paths to unrestrict
$pathsToUnrestrict = @(
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipTool.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipHomePage.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipWorker.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "Protect")  # Protect directory path
)

# Remove execution restrictions
Remove-ExecutionRestriction -PathsToUnrestrict $pathsToUnrestrict

Write-Log "HaoZip unrestriction process completed."
