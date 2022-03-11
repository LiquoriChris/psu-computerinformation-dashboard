function Get-NetAdapterInformation {
    <#
    .SYNOPSIS
        Get Network Adapter general information and where the status of the current connected adapter. 
    .NOTES
        Get-NetAdapter.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $NetworkAdapter = Get-NetAdapter -CimSession $ComputerName -ErrorAction Stop
        $NetworkAdapter |Foreach-Object {
            $ConnectedVia = $PSItem |Where-Object {
                $_.Name -NotMatch 'veth' -and $_.Status -eq 'Up'
            }
            $IPAddress = $ConnectedVia |Get-NetIPAddress -ErrorAction Stop |Where-Object addressfamily -eq 'ipv4'
            $ConnectedMacAddress = $ConnectedVia.MacAddress
            $NetworkAdapterInformation = [ordered]@{
                Name = $PSItem.Name
                Status = $PSItem.Status
                MacAddress = $PSItem.MacAddress
                InterfaceDescription = $PSItem.InterfaceDescription
                ConnectedVia = $ConnectedVia.Name
                IPAddress = $IPAddress.IPAddress
                ConnectedMacAddress = $ConnectedMacAddress
            }
            [pscustomobject]$NetworkAdapterInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\NetworkAdapter" -Message $ErrorMessage -LogType Error
    }
}