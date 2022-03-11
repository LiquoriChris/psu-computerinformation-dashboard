function Get-PowerPlanInformation {
    <#
    .SYNOPSIS
        Get Power Management information using CIM.
    .NOTES
        Class name: Win32_PowerPlan.
        Namespace: root\cimv2\power
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $PowerPlan = Get-CimInstance -CimSession $ComputerName -Namespace root\cimv2\power -ClassName win32_PowerPlan -ErrorAction Stop
        $PowerPlan |Foreach-Object {
            $PowerPlanInformation = [ordered]@{
                Name = $PSItem.ElementName
                Description = $PSItem.Description
                Active = $PSItem.IsActive
            }
            [pscustomobject]$PowerPlanInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\PowerPlan" -Message $ErrorMessage -LogType Error
    }
}