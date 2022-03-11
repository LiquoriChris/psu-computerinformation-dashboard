function New-ADComputerNameForm {
    [CmdletBinding()]
    param (
        [string]$OrganizationalUnit = ($Configuration.AD.OrganizationalUnit),
        [string]$Id = 'dynADComputerName',
        [switch]$SearchIntuneDevice
    )

    New-UDRow -Columns {
        New-UDColumn -SmallSize 3 -LargeSize 3 -Content {
            New-UDDynamic -Id $Id -Content {
                $ADComputerName = Get-PSUCache -Key ADComputerName
                if (-not($ADComputerName)) {
                    $Params = @{
                        SearchBase = $OrganizationalUnit
                        SearchScope = 2
                        Filter = 'Enabled -eq $true'
                    }
                    $ADComputerName = Get-ADComputer @Params |Select-Object -ExpandProperty Name
                    Set-PSUCache -Key ADComputerName -Value $ADComputerName -SlidingExpiration (New-TimeSpan -Days 1)
                }
                New-UDAutoComplete -Id txtComputerName -FullWidth -Options $ADComputerName
            } -LoadingComponent {
                New-UDLoadingComponent -Text 'Loading AD Computers... Please wait'
            }
        }
        New-UDColumn -SmallSize 8 -LargeSize 8 -Content {
            if ($SearchIntuneDevice) {
                Search-IntuneDevice
            }
            New-UDButton -Text 'Refresh AD Computers' -Icon (New-UDIcon -Icon sync) -OnClick {
                Show-UDModal -FullWidth -MaxWidth sm -Persistent -Content {
                    New-UDDynamic -Content {
                        $Params = @{
                            SearchBase = $OrganizationalUnit
                            SearchScope = 2
                            Filter = 'Enabled -eq $true'
                        }
                        $ADComputerName = Get-ADComputer @Params |Select-Object -ExpandProperty Name
                        Set-PSUCache -Key ADComputerName -Value $ADComputerName -SlidingExpiration (New-TimeSpan -Days 1)
                        Hide-UDModal
                        Sync-UDElement -Id $Id
                    } -LoadingComponent {
                        New-UDLoadingComponent -Text 'Loading AD Computers... Please wait'
                    }
                }
            }
        }
    }
}