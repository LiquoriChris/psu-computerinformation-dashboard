function Get-SoftwareInformation {
    <#
    .SYNOPSIS
        Get software information using CIM.
    .NOTES
        Class name: Win32Reg_AddRemovePrograms.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Software = Get-CimInstance -CimSession $ComputerName -ClassName Win32Reg_AddRemovePrograms -ErrorAction Stop |Where-Object DisplayName |Sort-Object InstallDate -Descending
        $Software |Foreach-Object {
            $SoftwareInformation = [ordered]@{
                Name = $PSItem.DisplayName
                Version = if ($PSItem.Version) {
                    $PSItem.Version
                }
                else {
                    Write-Output 'N/A'
                }
                Installed = if ($PSItem.InstallDate) {
                    if ($PSItem.InstallDate -match '\d\/\d\d\/\d\d\d\d') {
                        $PSItem.InstallDate
                    }
                    else {
                        $Date = ($PSItem.InstallDate |Select-String '(\d{4})(\d{2})(\d{2})')
                        Get-Date -Date ($Date.Matches.Groups[2,3,1] -join '/') -Format 'M/d/yyyy'
                    }
                }
                else {
                    Write-Output 'N/A'
                }
            }
            [pscustomobject]$SoftwareInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Software" -Message $ErrorMessage -LogType Error
    }
}