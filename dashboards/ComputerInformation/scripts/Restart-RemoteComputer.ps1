function Restart-RemoteComputer {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Params = @{
            ComputerName = $ComputerName
            Force = $true
            Wait = $true
            For = 'WinRM'
            Delay = 2
            ErrorAction = 'Stop'
        }
        Restart-Computer @Params
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\RestartComputer" -Message $ErrorMessage -LogType Error
    }
}