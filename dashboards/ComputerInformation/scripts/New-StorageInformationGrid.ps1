function New-StorageInformationGrid {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    New-UDGrid -Item -ExtraSmallSize 4 -Content {
        New-UDDynamic -Id dynStorage -Content {
            $StorageInformation = Get-StorageInformation -ComputerName $ComputerName
            $BitlockerInformation = Get-BitlockerInformation -ComputerName $ComputerName
            $Body = New-UDCardBody -Content {
                New-UDRow -Columns {
                    New-UDColumn -Content {
                        New-UDTextbox -Icon (New-UDIcon -Icon HDD) -Value Storage -Disabled -FullWidth
                    }
                    New-UDRow -Columns {
                        New-UDColumn -SmallSize 2 -LargeSize 2 -Content {}
                        New-UDColumn -SmallSize 5 -LargeSize 5 -Content {
                            New-UDChartJS -Type horizontalBar -Data $StorageInformation -DataProperty SizeRemaining -LabelProperty Capacity -BackgroundColor green -Options @{
                                display = $false
                            }
                        }
                        New-UDColumn -SmallSize 5 -LargeSize 5 -Content {}
                    }
                    New-UDRow -Columns {
                        New-UDColumn -Content {
                            New-UDElement -Tag BR
                            $Columns = @(
                                New-UDTableColumn -Title Drive -Property Drive -IncludeInSearch -IncludeInExport
                                New-UDTableColumn -Title EncryptionStatus -Property EncryptionStatus -IncludeInSearch -IncludeInExport
                            )
                            New-UDTable -Title BitLocker -Data $BitlockerInformation -Columns $Columns -Dense -ShowExport
                        }
                    }
                }
            }
            $Footer = New-UDCardFooter -Content {
                New-UDSyncButton -Id dynStorage
            }
            New-UDCard -Body $Body -Footer $Footer
        } -LoadingComponent {
            New-UDLoadingComponent -Text 'Loading storage information...'
        }
    }
}