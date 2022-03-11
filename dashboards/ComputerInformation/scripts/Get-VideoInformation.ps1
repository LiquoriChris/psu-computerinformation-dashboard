function Get-VideoInformation {
    <#
    .SYNOPSIS
        Get Video information using CIM.
    .NOTES
        Class name: Win32_VideoController.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Video = Get-CimInstance -CimSession $ComputerName -ClassName win32_VideoController -ErrorAction Stop
        $Video |Foreach-Object {
            if ($PSItem.DriverDate) {
                $DriverDate = Get-Date -Date $PSItem.DriverDate -Format g
            }
            else {
                $DriverDate = 'N/A'
            }
            if ($PSItem.DriverVersion) {
                $DriverVersion = $PSItem.DriverVersion
            }
            else {
                $DriverVersion = 'N/A'
            }
            $VideoInformation = [ordered]@{
                Name = $PSItem.Name
                Status = $PSItem.Status
                DeviceID = $PSItem.DeviceID
                VideoProcessor = $PSItem.VideoProcessor
                DriverDate = $DriverDate
                DriverVersion = $DriverVersion
            }
            [pscustomobject]$VideoInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Video" -Message $ErrorMessage -LogType Error
    }
}