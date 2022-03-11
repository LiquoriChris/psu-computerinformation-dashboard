function Get-BitlockerInformation {
    <#
    .SYNOPSIS
        Get Bitlocker drives and encryption status using CIM.
    .NOTES
        Class name: Win32_EncryptableVolume.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Bitlocker = Get-CimInstance -CimSession $ComputerName -ClassName Win32_EncryptableVolume -Namespace root\CIMV2\Security/MicrosoftVolumeEncryption
        $Bitlocker |Foreach-Object {
            $BitlockerInformation = @{
                Drive = if ($PSItem) {
                    $PSItem.DriveLetter
                }
                EncryptionStatus = if ($PSItem) {
                    $Status = switch ($PSItem.ProtectionStatus) {
                        0 {'Unprotected'}
                        1 {'Protected'}
                        2 {'Unknown'}
                    }
                    $Status
                }
                else {
                    Write-Output 'N/A'
                }
            }
            [pscustomobject]$BitlockerInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Bitlocker" -Message $ErrorMessage -LogType Error
    }
}