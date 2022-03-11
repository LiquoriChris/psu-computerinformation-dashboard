function New-CPUMemoryInformationGrid {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    New-UDGrid -Item -ExtraSmallSize 4 -Content {
        New-UDDynamic -Id dynCPUMemory -Content {
            $Params = @{
                ComputerName = $ComputerName
            }
            $CPUInformation = Get-CPUInformation @Params
            $MemoryInformation = Get-MemoryInformation @Params
            $Body = New-UDCardBody -Content {
                New-UDRow -Columns {
                    New-UDColumn -Content {
                        New-UDTextbox -Icon (New-UDIcon -Icon Microchip) -Value 'CPU and Memory' -Disabled -FullWidth
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'CPU Name' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $CPUInformation.Name
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'CPU Speed' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $CPUInformation.Speed
                        New-UDElement -Tag BR
                    }
                    New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                        New-UDElement -Tag BR
                        New-UDTypography -Text 'Processors' -FontWeight bold
                        New-UDElement -Tag BR
                        New-UDTypography -Text $CPUInformation.Processor
                        New-UDElement -Tag BR
                    }
                    New-UDRow -Columns {
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'Core Count' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text $CPUInformation.Core
                            New-UDElement -Tag BR
                        }
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'Memory' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text ($MemoryInformation.TotalMemory |Select-Object -Unique)
                            New-UDElement -Tag BR
                        }
                        New-UDColumn -SmallSize 4 -LargeSize 4 -Content {
                            New-UDElement -Tag BR
                            New-UDTypography -Text 'Memory Slots' -FontWeight bold
                            New-UDElement -Tag BR
                            New-UDTypography -Text ($MemoryInformation.Slots |Select-Object -Unique)
                            New-UDElement -Tag BR
                        }
                    }
                }
            }
            $Footer = New-UDCardFooter -Content {
                New-UDSyncButton -Id dynCPUMemory
            }
            New-UDCard -Body $Body -Footer $Footer
        } -LoadingComponent {
            New-UDLoadingComponent -Text 'Loading cpu and memory information...'
        }
    }
}