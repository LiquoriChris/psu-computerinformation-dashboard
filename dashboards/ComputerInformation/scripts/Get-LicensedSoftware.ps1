function Get-LicensedSoftware {
    [CmdletBinding()]
    param (
        [string]$ComputerName,
        [string[]]$ApplicationName = ($Configuration.LicensedApplication)
    )

    Show-UDModal -Persistent -FullWidth -MaxWidth md -Content {
        New-UDDynamic -Content {
            Try {
                $Data = Invoke-Command -ComputerName $ComputerName -ArgumentList $ApplicationName -ScriptBlock {
                    Get-ChildItem -Path 'C:\Program Files','C:\Program Files (x86)' -Filter "$($args).exe" -Recurse |Get-ItemProperty |Foreach-Object {
                        if ($PSItem.LastAccessTime) {
                            $LastAccessed = Get-Date -Date $PSItem.LastAccessTime -Format g
                        }
                        else {
                            $LastAccessed = Write-Output 'N/A'
                        }
                        [pscustomobject]@{
                            Name = $PSItem.VersionInfo.CompanyName
                            Version = $PSItem.VersionInfo.ProductVersion
                            LastAccessed = $LastAccessed
                        }
                    }
                }
                $Columns = @(
                    New-UDTableColumn -Title Name -Property Name -IncludeInSearch -IncludeInExport
                    New-UDTableColumn -Title Version -Property Version -IncludeInSearch -IncludeInExport
                    New-UDTableColumn -Title LastAccessed -Property LastAccessed -IncludeInSearch -IncludeInExport
                )
                $Table = New-UDTable -Title 'Licensed Software' -Data $Data -Columns $Columns -Dense -ShowExport -ShowSearch
                if ($Table.data) {
                    $Table
                }
                else {
                    New-UDAlert -Severity info -Message "No licensed software has been found on $ComputerName"
                }
            }
            Catch {
                $ErrorMessage = $_
                Write-Warning $ErrorMessage
                Write-Log -FolderName "$DashboardName\LicensedApplication" -Message $ErrorMessage -LogType Error
            }
        } -LoadingComponent {
                New-UDLoadingComponent -Text 'Loading licensed software... Please wait'
            }
    } -Footer {
        New-UDButton -Text 'Close' -OnClick {
            Hide-UDModal
        }
    }
}