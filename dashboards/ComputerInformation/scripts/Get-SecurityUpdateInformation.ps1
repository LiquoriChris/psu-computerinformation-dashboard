function Get-SecurityUpdateInformation {
    <#
    .SYNOPSIS
        Get SecurityUpdate information using CIM.
    .NOTES
        Class name: Win32_QuickFixEngineering.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $SecurityUpdate = Get-CimInstance -CimSession $ComputerName -ClassName Win32_QuickFixEngineering -ErrorAction Stop |Sort-Object InstalledOn -Descending
        $SecurityUpdate |Foreach-Object {
            $SecurityUpdateInformation = [ordered]@{
                Name = $PSItem.Description
                KB = $PSItem.HotFixID
                Installed = (Get-Date -Date $PSItem.InstalledOn -Format g)
            }
            [pscustomobject]$SecurityUpdateInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\SecurityUpdate" -Message $ErrorMessage -LogType Error
    }
}