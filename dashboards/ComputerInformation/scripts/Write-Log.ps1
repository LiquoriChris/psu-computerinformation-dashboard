function Write-Log {
    [CmdletBinding()]
    param (
        [string]$FolderName,
        [string]$FileName = (Get-Date -Format 'yyyyMMdd'),
        [string]$Message,
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]$LogType = 'Information',
        [switch]$NoLogInformation
    )

    Try {
        $LogTypeCode = switch ($LogType) {
            'Information' {'INF'}
            'Warning' {'WRN'}
            'Error' {'ERR'}
        }
        $LogPath = Join-Path -Path $env:ProgramData -ChildPath "PowerShellUniversal\logs\$FolderName"
        if (-not(Test-Path -Path $LogPath)) {
            New-Item -Path $LogPath -ItemType Directory |Out-Null
        }
        $TimeStamp = Get-Date -UFormat '%D %T'
        $Params = @{
            Path = "$LogPath\$($FileName).log"
        }
        if ($NoLogInformation) {
            $Params.Value = $Message
        }
        else {
            $Params.Value = "$TimeStamp [$LogTypeCode] $Message"
        }
        Add-Content @Params

    }
    Catch {
        throw $_
    }
}