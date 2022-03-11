function New-GeneralInformationGrid {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    New-UDGrid -Item -ExtraSmallSize 4 -Content {
        New-UDDynamic -Id dynGeneral -Content {
            $Params = @{
                ComputerName = $ComputerName
            }
            $ComputerSystemInformation = Get-ComputerSystemInformation @Params
            $OperatingSystemInformation = Get-OperatingSystemInformation @Params
            $BIOSInformation = Get-BIOSInformation @Params
            $Body = New-UDCardBody -Content {
                New-UDRow -Columns {
                    New-UDColumn -Content {
                        New-UDTextbox -Icon (New-UDIcon -Icon desktop) -Value General -Disabled -FullWidth
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'Device Name' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $ComputerSystemInformation.Name
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'Device Model' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $ComputerSystemInformation.Model
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'User' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $ComputerSystemInformation.User
                        New-UDElement -Tag BR
                    }
                    New-UDRow -Columns {
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'Serial Number' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text $BIOSInformation.SerialNumber
                            New-UDElement -Tag BR
                        }
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'OS Name' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text $OperatingSystemInformation.Name
                            New-UDElement -Tag BR
                        }
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'OS Version' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text $OperatingSystemInformation.Version
                            New-UDElement -Tag BR
                        }
                    }
                }
            }
            $Footer = New-UDCardFooter -Content {
                New-UDSyncButton -Id dynGeneral
            }
            New-UDCard -Body $Body -Footer $Footer
        } -LoadingComponent {
            New-UDLoadingComponent -Text 'Loading general information...'
        }
    }
}