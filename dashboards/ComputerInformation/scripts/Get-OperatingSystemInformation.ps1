function Get-OperatingSystemInformation {
    <#
    .SYNOPSIS
        Get Operating System information using CIM.
    .NOTES
        Class name: Win32_OperatingSystem.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $OperatingSystem = Get-CimInstance -CimSession $ComputerName -ClassName win32_OperatingSystem -ErrorAction Stop
        $OperatingSystemInformation = [ordered]@{
            Name = if ($OperatingSystem.Name) {
                if ($OperatingSystem.Name -match '.*\|.*') {
                    ($OperatingSystem.Name).Split('|')[0]
                }
                else {
                    $OperatingSystem.Name
                }
            }
            Version = $OperatingSystem.Version
            Build = $OperatingSystem.BuildNumber
            LastRestart = Get-Date -Date $OperatingSystem.LastBootUpTime -Format g
        }
        [pscustomobject]$OperatingSystemInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\OperatingSystem" -Message $ErrorMessage -LogType Error
    }
}