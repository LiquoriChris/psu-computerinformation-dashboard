function Get-ComputerSystemInformation {
    <#
    .SYNOPSIS
        Get ComputerSystem information using CIM.
    .NOTES
        Class name: Win32_ComputerSystem.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $ComputerSystem = Get-CimInstance -CimSession $ComputerName -ClassName win32_ComputerSystem -ErrorAction Stop
        $ComputerSystemInformation = [ordered]@{
            Name = $ComputerSystem.Name
            Model = $ComputerSystem.Model
            State = $ComputerSystem.Status
            User = if ($ComputerSystem.UserName) {
                $ComputerSystem.UserName -replace '.*\\',''
            }
            else {
                Write-Output 'N/A'
            }
        }
        [pscustomobject]$ComputerSystemInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\ComputerSystem" -Message $ErrorMessage -LogType Error
    }
}