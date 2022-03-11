function New-ComputerInformationGrid {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    New-UDGrid -Item -ExtraSmallSize 8 -Content {
        $Body = New-UDCardBody -Content {
            New-UDExpansionPanelGroup -Content {
                New-ComputerInformationExpansionPanel @Params -Name Monitor -Script Get-MonitorInformation -ColumnName Manufacturer,Model, SerialNumber, Size   
                New-ComputerInformationExpansionPanel @Params -Name Software -Script Get-SoftwareInformation -ColumnName Name, Version, Installed -ShowSearch
            }
        }
        $Footer = New-UDCardFooter -Content {
            New-UDButton -Text 'View All Computer Information' -OnClick {
                Invoke-UDRedirect -Url "/computerinformation?ComputerName=$ComputerName" -OpenInNewWindow
            }
        }
        New-UDCard -Body $Body -Footer $Footer
    }
}