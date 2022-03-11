function Get-AOVPNInformation {
    <#
    .SYNOPSIS
        Get AlwaysOn VPN information.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $AOVPN = Get-VpnConnection -CimSession $ComputerName -AllUserConnection -ErrorAction Stop
        $AOVPNInformation = [ordered]@{
            Name = $AOVPN.Name
            Status = $AOVPN.ConnectionStatus
            ServerAddress = $AOVPN.ServerAddress
        }
        [pscustomobject]$AOVPNInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\AOVPN" -Message $ErrorMessage -LogType Error
    }
}