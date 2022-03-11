function New-ComputerInformationScanForm {
    [CmdletBinding()]
    param (
        [switch]$SearchIntuneDevice
    )

    $Body = New-UDCardBody -Content {
        New-UDForm -ButtonVariant outlined -Content {
            $Params = @{}
            if ($SearchIntuneDevice) {
                $Params.SearchIntuneDevice = $true
            }
            New-ADComputerNameForm @Params
        } -OnValidate {
            if (-not($EventData.txtComputerName)) {
                New-UDValidationResult -ValidationError "ComputerName field is required"
            }
            elseif (-not(Get-ADComputer -Filter "Name -eq '$($EventData.txtComputerName)'" -ErrorAction SilentlyContinue)) {
                New-UDValidationResult -ValidationError "$($EventData.txtComputerName) not found in Active Directory"
            }
            elseif (-not(Test-Connection -TargetName $EventData.txtComputerName -Ping -Count 2 -Quiet)) {
                New-UDFormValidationResult -ValidationError "$($EventData.txtComputerName) is not accessible on the network"
            }
            else {
                New-UDFormValidationResult -Valid
            }
        } -OnSubmit {
            Sync-UDElement -Id dynComputerInformationScanForm
            Set-UDElement -Id elmComputerInformationScanForm -Content {
                $ComputerName = $EventData.txtComputerName
                New-UDDynamic -Id dynComputerInformationScanForm -Content {
                    $Params = @{
                        ComputerName = $ComputerName
                    }
                    New-UDRow -Columns {
                        $RestrictedComputerName = $Configuration.AD.RestrictedGroup |Get-ADGroup |Get-ADGroupMember |Select-Object -ExpandProperty Name
                        if ($ComputerName -notin $RestrictedComputerName) {
                            New-UDChip -Id chipPowerShellCode -Icon (New-UDIcon -Icon Terminal) -Label 'Execute Command' -OnClick {
                                New-RemotePowerShellCommand @Params
                            }
                            New-UDChip -Icon (New-UDIcon -Icon redo) -Label Restart -OnClick {
                                Show-UDModal -Content {
                                    New-UDButton -Text "Are you sure to restart $ComputerName?" -OnClick {
                                        Show-UDModal -Persistent -Content {
                                            New-UDTypography -Text "Restart in progress on: $ComputerName... Please wait"
                                            New-UDProgress
                                            Try {
                                                Restart-RemoteComputer @Params
                                                Hide-UDModal
                                                Show-UDToast -Message "$ComputerName has restarted successfully" -Duration 5000
                                            }
                                            Catch {
                                                Hide-UDModal
                                                Show-UDToast -Message $Error[0] -Duration 5000 -BackgroundColor red
                                            }
                                        }
                                    }
                                }
                            }
                            New-UDChip -Icon (New-UDIcon -Icon poweroff) -Label Shutdown -OnClick {
                                Show-UDModal -Content {
                                    New-UDButton -Text "Are you sure to shutdown $ComputerName?" -OnClick {
                                        Show-UDModal -Persistent -Content {
                                            New-UDTypography -Text "Shutdown in progress on: $ComputerName... Please wait"
                                            New-UDProgress
                                            Try {
                                                Stop-RemoteComputer @Params
                                                Hide-UDModal
                                                Show-UDToast -Message "$ComputerName has restarted successfully" -Duration 5000
                                            }
                                            Catch {
                                                Hide-UDModal
                                                Show-UDToast -Message $Error[0] -Duration 5000 -BackgroundColor red
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        New-UDChip -Icon (New-UDIcon -Icon key) -Label 'Licensed Software' -OnClick {
                            Get-LicensedSoftware @Params
                        }
                    }
                    New-UDGrid -Container -Content {
                        New-GeneralInformationGrid @Params
                        New-NetworkInformationGrid @Params
                        New-CPUMemoryInformationGrid @Params
                        New-StorageInformationGrid @Params
                        New-ComputerInformationGrid @Params
                    }
                } -LoadingComponent {
                    New-UDLoadingComponent -Text 'Loading computer information... Please wait'
                }
            }
        }
    }
    $Params = @{
        Title = 'Enter a computer find information about the selected computer, the list will filter when text is entered'
    }
    if ($SearchIntuneDevice) {
        $Params.SubHeader = "Use the 'Search for Device' button to search for device by username"
    }
    $Header = New-UDCardHeader @Params
    New-UDCard -Body $Body -Header $Header
    New-UDElement -Id elmComputerInformationScanForm -Tag div
}