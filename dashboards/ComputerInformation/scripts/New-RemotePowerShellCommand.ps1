function New-RemotePowerShellCommand {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    $FolderPath = "$DashboardName\RemoteCommand\$ComputerName"
    Show-UDModal -Persistent -FullWidth -MaxWidth lg -Content {
        New-UDCodeEditor -Id codePowerShell -Language powershell -Height 500
    } -Footer {
        New-UDButton -Id btnExecutePowerShellCommand -Text Execute -OnClick {
            Set-UDElement -Id btnExecutePowerShellCommand -Properties @{
                disabled = $true
            }
            $Code = (Get-UDElement -Id codePowerShell).code
            $ScriptBlock = [ScriptBlock]::Create($Code)
            Write-Log -FolderName $FolderPath -Message "Command run by: $User"
            Write-Log -FolderName $FolderPath -Message $Code
            Show-UDModal -Persistent -FullWidth -MaxWidth md -Content {
                New-UDTypography -Text 'Executing...' -Variant h6
                New-UDProgress
            }
            $Params = @{
                ComputerName = $ComputerName
                ArgumentList = $Code
                ScriptBlock = $ScriptBlock
            }
            $Output = Invoke-Command @Params
            if ($Output) {
                $session:Output = $Output |Out-String
            }
            elseif ($Error[0]) {
                $session:Output = $Error[0] -join [Environment]::NewLine
            }
            else {
                $session:Output = Write-Output 'Command produced no output'
            }
            Write-Log -FolderName $FolderPath -Message $session:Output
            Set-UDElement -Id btnExecutePowerShellCommand -Properties @{
                disabled = $false
            }
            Hide-UDModal
            Show-UDModal -Persistent -FullWidth -MaxWidth lg -Content {
                New-UDCodeEditor -Code $session:Output -ReadOnly -Height 500
            } -Footer {
                New-UDButton -Text 'New Command' -OnClick {
                    $JavaScript = @'
                            var button = document.getElementById("chipPowerShellCode");
                            button.click();
'@
                    Invoke-UDJavaScript -JavaScript $JavaScript
                }
                New-UDButton -Text Close -OnClick {
                    Hide-UDModal
                }
            }
        }
        $HistoryPath = Join-Path -Path "$env:ProgramData\PowerShellUniversal\logs\$DashboardName\RemoteCommand" -ChildPath $ComputerName
        $HistoryFile = Get-ChildItem -Path $HistoryPath -File -ErrorAction SilentlyContinue |Sort-Object LastWriteTime -Descending
        if ($HistoryFile) {
            New-UDButton -Text History -OnClick {
                Show-UDModal -FullWidth -MaxWidth sm -Content {
                    New-UDHeading -Text "Select a log folder to see history of commands run for $ComputerName"
                    New-UDForm -Content {
                        New-UDSelect -Id selHistoryFile -FullWidth -Option {
                            foreach ($File in $HistoryFile) {
                                New-UDSelectOption -Name $File.Name -Value $File.Name
                            }
                        }
                    } -OnSubmit {
                        Show-UDModal -FullWidth -MaxWidth lg -Content {
                            New-UDHeading -Text "Showing history from $($EventData.selHistoryFile)"
                            $session:History = Get-Content -Path (Join-Path $HistoryPath -ChildPath $EventData.selHistoryFile) -Raw |Out-String
                            New-UDCodeEditor -Code $session:History -ReadOnly -Height 500
                        } -Footer {
                            New-UDButton -Text Close -OnClick {
                                Hide-UDModal
                            }
                        }
                    }
                }
            }
        }
        New-UDButton -Text Cancel -OnClick {
            Hide-UDModal
        }
    }
}