function Get-BIOSInformation {
    <#
    .SYNOPSIS
        Get BIOS information using CIM.
    .NOTES
        Class name: Win32_BIOS.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $BIOS = Get-CimInstance -CimSession $ComputerName -ClassName win32_BIOS -ErrorAction Stop
        $BIOSInformation = [ordered]@{
            Date = Get-Date -Date $BIOS.ReleaseDate -Format g
            Name = $BIOS.Name
            Manufacturer = $BIOS.Manufacturer
            SerialNumber = $BIOS.SerialNumber
            Firmware = $BIOS.Version
        }
        [pscustomobject]$BIOSInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\BIOS" -Message $ErrorMessage -LogType Error
    }
}