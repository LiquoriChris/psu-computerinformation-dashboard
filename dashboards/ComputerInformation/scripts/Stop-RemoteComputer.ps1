function Stop-RemoteComputer {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Params = @{
            ComputerName = $ComputerName
            Force = $true
        }
        Stop-Computer @Params
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\StopComputer" -Message $ErrorMessage -LogType Error
    }
}