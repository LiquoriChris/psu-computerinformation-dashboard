function Get-BatteryInformation {
    <#
    .SYNOPSIS
        Get Battery information using CIM.
    .NOTES
        Class name: Win32_Battery.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Battery = Get-CimInstance -CimSession $ComputerName -ClassName win32_Battery -ErrorAction Stop
        $BatteryInformation = [ordered]@{
            Name = $Battery.Name
            DeviceID = $Battery.DeviceID
            Status = $Battery.Status
            ChargeRemaining = "$($Battery.EstimatedChargeRemaining) %"
            RunTimeRemaining = if ($Battery.EstimatedRunTime -eq 71582788) {
                Write-Output 'AC Power'
            }
            else {
                $Value = $Battery.EstimatedRunTime / 60
                Write-Output $Value
            }
        }
        [pscustomobject]$BatteryInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Battery" -Message $ErrorMessage -LogType Error
    }
}