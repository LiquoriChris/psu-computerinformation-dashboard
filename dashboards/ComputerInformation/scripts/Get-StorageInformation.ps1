function Get-StorageInformation {
    <#
    .SYNOPSIS
        Get Storage (Volume) information.
    .NOTES
        Get-Volume.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Volume = Get-Volume -CimSession $ComputerName |Where-Object DriveLetter
        $Volume |Foreach-Object {
            $SizeRemaining = [math]::Round($PSItem.SizeRemaining / 1gb)
            $Size = [math]::Round($PSItem.Size / 1gb)
            $StorageInformation = @{
                Capacity = "$SizeRemaining of $Size GB used"
                TotalSize = if ($Size) {
                    $Size
                }
                SizeRemaining = if ($SizeRemaining) {
                    $SizeRemaining
                }
                else {
                    Write-Output 'N/A'
                }
                DriveLetter = $PSItem.DriveLetter
                DriveType = $PSItem.DriveType
                FileSystemType = $PSItem.FileSystemType
                Status = $PSItem.HealthStatus
            } 
            [pscustomobject]$StorageInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Storage" -Message $ErrorMessage -LogType Error
    }
}