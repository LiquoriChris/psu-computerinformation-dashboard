function New-ComputerInformationExpansionPanel {
    <#
    .SYNOPSIS
        Create a custom expansion panel. 
    .DESCRIPTION
        Function will create a dynamic expansion panel by calling a function and creating a object and table based off the specified parameters.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName,
        [string]$Name,
        [string]$Script,
        [string[]]$ColumnName,
        [switch]$ShowSearch
    )

    New-UDExpansionPanel -Title $Name -Content {
        New-UDDynamic -Id "dyn$($Name)InformationExpansionPanelTable" -Content {
            $Columns = $Columns
            $ScriptBlock = [scriptblock]::Create($Script)
            $Data = Invoke-Expression "& $ScriptBlock -ComputerName $ComputerName"
            $Params = @{
                Data = $Data
                Dense = $true
                ShowExport = $true
                ShowSort = $true
            }
            if ($ColumnName) {
                $Columns = @(
                    foreach ($Column in $ColumnName) {
                        New-UDTableColumn -Title $Column -Property $Column
                    }
                )
                $Params.Columns = $Columns
            }
            if ($ShowSearch) {
                $Params.ShowSearch = $true
            }
            $Table = New-UDTable @Params
            if ($Table.data) {
                New-UDSyncButton -Id "dyn$($Name)InformationExpansionPanelTable"
                $Table
            }
            else {
                New-UDAlert -Severity info -Text "Could not find $Name information"
            }
        } -LoadingComponent {
            New-UDLoadingComponent -Text "Loading $Name information..."
        }
    }
}