#requires -Modules MSOnline

function Connect-Microsoft365 {
    param (
        [switch]$UseWindowsPowerShell,
        [pscredential]$Credential
    )

    $Params = @{
        Name = 'MSOnline'
    }
    if ($UseWindowsPowerShell) {
        $Params.UseWindowsPowerShell = $true
    }
    if (-not(Get-Module -Name $Params.Name)) {
        Import-Module @Params
    }
    Try {
        Get-MsolDomain -ErrorAction Stop |Out-Null
    }
    Catch {
        Try {
            Connect-MsolService -Credential $Credential -ErrorAction Stop
        }
        Catch {
            New-UDErrorBoundary -Content {
                throw $_
            }
        }
    }
}
