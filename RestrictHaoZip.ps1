# RestrictHaoZip.ps1
# Requires PowerShell to be run as Administrator
# This script retrieves the HaoZip installation directory, uninstalls "安全组件 - 2345" application,
# stops and deletes related services, terminates related processes, and applies execution restrictions
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

# Step 2: Uninstall the "安全组件 - 2345" application
function Remove-SecurityComponent {
    Write-Log "Starting Step 2: Uninstalling application - 安全组件 - 2345"
    $safeAppName = "安全组件 - 2345"
    $uninstallString = (Get-ItemProperty -Path $uninstallPaths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq $safeAppName }).UninstallString

    if ($uninstallString) {
        try {
            Start-Process -FilePath $uninstallString -NoNewWindow -Wait
            Write-Log "Step 2 completed: $safeAppName uninstallation completed successfully."
        } catch {
            Write-Log "Step 2 failed: Could not uninstall $safeAppName."
        }
    } else {
        Write-Log "Step 2 notice: $safeAppName not found in the specified paths. Skipping uninstallation."
    }
}

# Step 3: Delete a specified service
function Remove-ExistingService {
    param (
        [string]$ServiceName
    )
    Write-Log "Attempting to delete service - $ServiceName"
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($service) {
            Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
            sc.exe delete $ServiceName | Out-Null
            Write-Log "Service $ServiceName deleted successfully."
        } else {
            Write-Log "Notice: Service $ServiceName does not exist. Skipping deletion."
        }
    } catch {
        Write-Log "Failed: Could not delete service $ServiceName."
    }
}

# Step 4: Terminate processes and apply ACL restrictions
function Stop-ProcessesAndRestrictACL {
    param (
        [string[]]$PathsToRestrict
    )
    Write-Log "Starting Step 4: Stopping related processes and applying ACL restrictions."

    $aclDenyExecution = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "ExecuteFile", "Deny")

    foreach ($path in $PathsToRestrict) {
        if (Test-Path -Path $path) {
            try {
                $processes = Get-Process | Where-Object { $_.Path -like "$path*" } -ErrorAction SilentlyContinue
                if ($processes) {
                    $processes | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue }
                    Write-Log "All processes for $path terminated successfully."
                } else {
                    Write-Log "Notice: No running processes found for $path."
                }
                
                # Apply ACL restriction
                $acl = Get-Acl -Path $path
                $acl.AddAccessRule($aclDenyExecution)
                Set-Acl -Path $path -AclObject $acl
                Write-Log "Execution permissions restricted for $path"
            } catch {
                Write-Log "Failed: Could not terminate processes or restrict execution for $path."
            }
        } else {
            Write-Log "Notice: Path $path does not exist. Skipping termination and ACL restriction."
        }
    }
}

# Main execution
$haoZipPath = Get-HaoZipPath
Remove-SecurityComponent

# Delete services
Remove-ExistingService -ServiceName "2345SafeCenterSvc"
Remove-ExistingService -ServiceName "2345HaoZip"

# Define paths to restrict
$pathsToRestrict = @(
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipTool.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipHomePage.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "HaoZipWorker.exe"),
    (Join-Path -Path $haoZipPath -ChildPath "Protect")  # Protect directory path
)

# Terminate processes and restrict execution
Stop-ProcessesAndRestrictACL -PathsToRestrict $pathsToRestrict

Write-Log "HaoZip restriction process completed."
