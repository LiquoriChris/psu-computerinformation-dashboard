function Get-DiskDriveInformation {
    <#
    .SYNOPSIS
        Get hard drive information using CIM.
    .NOTES
        Class name: Win32_DiskDrive.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $DiskDrive = Get-CimInstance -CimSession $ComputerName -ClassName Win32_DiskDrive -ErrorAction Stop
        $DiskDrive |Foreach-Object {
            $Size = [math]::Round($PSItem.Size / 1gb, 2)
            $DiskDriveInformation = [ordered]@{
                Name = $PSITem.Caption
                Status = $PSItem.Status
                Size = "$Size GB"
                Partitions = $PSItem.Partitions
                Model = $PSItem.Model
                SerialNumber = $PSItem.SerialNumber

            }
            [pscustomobject]$DiskDriveInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\DiskDrive" -Message $ErrorMessage -LogType Error
    }
}