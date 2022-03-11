function Get-NetConnectionProfileInformation {
    <#
    .SYNOPSIS
        Get network connection profile general information and any profiles that are domain authenticated.
    .NOTES
        Get-NetConnectionProfile.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName,
        [string]$DomainName = ($Configuration.InternalDomainName)
    )

    Try {
        $NetConnectionProfile = Get-NetConnectionProfile -CimSession $ComputerName -ErrorAction Stop  
        $NetConnectionProfile |Foreach-Object {
            $ConnectedTo = $PSItem |Where-Object Name -eq $DomainName
            $NetConnectionProfileInformation = [ordered]@{
                Name = $PSItem.Name
                InterfaceAlias = $PSItem.InterfaceAlias
                NetworkCategory = $PSItem.NetworkCategory
                ConnectedTo = $ConnectedTo.InterfaceAlias
            }
            [pscustomobject]$NetConnectionProfileInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\NetConnectionProfile" -Message $ErrorMessage -LogType Error
    }
}