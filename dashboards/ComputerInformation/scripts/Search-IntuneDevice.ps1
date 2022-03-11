function Search-IntuneDevice {
    <#
    .SYNOPSIS
        Search Intune device via UserName
    .DESCRIPTION
        Script will search Intune device via UserName and display the information in a table. A select button will copy the device name in the clipboard for use.
    .INPUTS
        DomainName. This is the suffix used when searching User Principal Names (UPN). Example: xyz.com
        
        Credential. The credential parameter is used to login to MSOnline to search for Intune devices by registered owner.
    .NOTES
        General notes
    #>
    param (
        [string]$DomainName = ($Configuration.DomainName),
        [pscredential]$Credential = $IntuneCredential
    )

    New-UDButton -Id btnSearchIntuneDevice -Text 'Search for Device' -Icon (New-UDIcon -Icon desktop) -OnClick {
        Show-UDModal -Persistent -FullWidth -MaxWidth sm -Content {
            New-UDForm -Content {
                New-UDTextbox -Id 'txtSearchUserName' -Label 'Enter UserName' -FullWidth -AutoFocus
            } -OnValidate {
                if (-not($EventData.txtSearchUserName)) {
                    New-UDFormValidationResult -ValidationError 'UserName field is required'
                }
                else {
                    New-UDFormValidationResult -Valid
                }
            } -OnSubmit {
                $UserName = $EventData.txtSearchUserName
                $UserPrincipalName = "$($UserName)@$($DomainName)"
                Show-UDModal -Content {
                    New-UDTypography -Text 'Logging into Microsoft 365. Please wait' -Variant "subtitle1" 
                    New-UDProgress -Circular
                    $Params = @{
                        Credential = $Credential
                        UseWindowsPowerShell = $true
                    }
                    Connect-Microsoft365 @Params
                    Hide-UDModal
                }
                $Params = @{
                    RegisteredOwnerUpn = $UserPrincipalName
                    ErrorAction = 'Stop'
                }
                Try {
                    $Data = Get-MsolDevice @Params |Where-Object {$_.DeviceTrustType -in ('Domain Joined','Azure AD Joined') -and $_.Enabled -eq $true} -ErrorAction Stop |ForEach-Object {
                        [pscustomobject]@{
                            ComputerName = $PSItem.DisplayName
                            Enabled = $PSItem.Enabled
                        }
                    }
                    Show-UDModal -Persistent -FullWidth -MaxWidth sm -Content {
                        if ($Data) {
                            New-UDHeading -Text 'Selection will be copied to clipboard'
                            $Columns = @(
                                New-UDTableColumn -Title Select -Property Select -Render {
                                    New-UDButton -Text "Select" -Onclick {
                                        Set-UDClipboard -Data $EventData.ComputerName -ToastOnSuccess
                                        Hide-UDModal
                                    }
                                }
                                New-UDTableColumn -Title ComputerName -Property ComputerName 
                                New-UDTableColumn -Title Enabled -Property Enabled    
                            )
                            New-UDTable -Data $Data -Columns $Columns -Dense
                        }
                        else {
                            New-UDAlert -Severity info -Text "No devices were found for $UserPrincipalName"
                        }
                    } -Footer {
                        New-UDButton -Text 'Cancel' -OnClick {
                            Hide-UDModal
                        }
                    }
                }
                Catch {
                    Show-UDToast -Message "$($UserPrincipalName) does not exist in Azure Active Directory... Please try again" -BackgroundColor red -Duration 5000
                    $JavaScript = @'
                            var button = document.getElementById("btnSearchIntuneDevice");
                            button.click();
'@
                    Invoke-UDJavaScript -JavaScript $JavaScript
                }
            }
        } -Footer {
            New-UDButton -Text Close -OnClick {
                Hide-UDModal
            }
        }
    }
}