function Get-CPUInformation {
    <#
    .SYNOPSIS
        Get CPU information using CIM.
    .NOTES
        Class name: Win32_Processor.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $CPU = Get-CimInstance -CimSession $ComputerName -ClassName win32_Processor -ErrorAction Stop
        $CPUInformation = [ordered]@{
            Name = $CPU.Name
            Core = $CPU.NumberOfCores
            Processor = $CPU.DeviceId.Count
            Speed = ($CPU.MaxClockSpeed / 1000)
        }
        [pscustomobject]$CPUInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\CPU" -Message $ErrorMessage -LogType Error
    }
}