function New-NetworkInformationGrid {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    New-UDGrid -Item -ExtraSmallSize 4 -Content {
        New-UDDynamic -Id dynNetwork -Content {
            $Params = @{
                ComputerName = $ComputerName
            }
            $NetAdapterInformation = Get-NetAdapterInformation @Params
            $AOVPNInformation = Get-AOVPNInformation @Params
            $NetConnectionProfileInformation = Get-NetConnectionProfileInformation @Params
            $Body = New-UDCardBody -Content {
                New-UDRow -Columns {
                    New-UDColumn -Content {
                        New-UDTextbox -Icon (New-UDIcon -Icon NetworkWired) -Value Network -Disabled -FullWidth
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'IP Address' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text ($NetAdapterInformation |Where-Object IPAddress).IPAddress
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'Connected To' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text ($NetConnectionProfileInformation |Where-Object ConnectedTo).ConnectedTo
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'Connected Via' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text ($NetAdapterInformation |Where-Object ConnectedVia).ConnectedVia
                        New-UDElement -Tag BR
                    }
                    New-UDRow -Columns {
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'AOVPN Status' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text $AOVPNInformation.Status
                            New-UDElement -Tag BR
                        }
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'MAC Address' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text ($NetAdapterInformation |Where-Object ConnectedMacAddress).ConnectedMacAddress
                            New-UDElement -Tag BR
                            New-UDElement -Tag BR
                        }
                    }
                }
            }
            $Footer = New-UDCardFooter -Content {
                New-UDSyncButton -Id dynNetwork
            }
            New-UDCard -Body $Body -Footer $Footer
        } -LoadingComponent {
            New-UDLoadingComponent -Text 'Loading network information...'
        }
    }
}