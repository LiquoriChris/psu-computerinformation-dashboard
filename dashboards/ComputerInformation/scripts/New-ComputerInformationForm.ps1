function New-ComputerInformationForm {
    [CmdletBinding()]
    param (
        [switch]$SearchIntuneDevice
    )

    if ($ComputerName) {
        $ADComputerCache = Get-PSUCache -Key ADComputerName
        if ($ComputerName -notin $ADComputerCache) {
            New-UDError -Title Error -Message "$ComputerName is not in the list of computer names"
            New-UDButton -Text 'Return' -OnClick {
                Invoke-UDRedirect -Url '/computerinformation' -OpenInNewWindow
            }
        }
        else {
            New-ComputerInformationExpansionPanelGroup -ComputerName $ComputerName
        }
    }
    else {
        $Body = New-UDCardBody -Content {
            New-UDForm -ButtonVariant outlined -Content {
                $Params = @{}
                if ($SearchIntuneDevice) {
                    $Params.SearchIntuneDevice = $true
                }
                New-ADComputerNameForm @Params
            } -OnValidate {
                $FormData = $EventData
                if (-not($FormData.txtComputerName)) {
                    New-UDValidationResult -ValidationError "$($FormData.txtComputerName) ComputerName field is required"
                }
                elseif (-not(Get-ADComputer -Filter "Name -eq '$($FormData.txtComputerName)'" -ErrorAction SilentlyContinue)) {
                    New-UDValidationResult -ValidationError "$($FormData.txtComputerName) not found in Active Directory"
                }
                elseif (-not(Test-Connection -TargetName $FormData.txtComputerName -Ping -Count 2 -Quiet)) {
                    New-UDFormValidationResult -ValidationError "$($FormData.txtComputerName) is not accessible on the network"
                }
                else {
                    New-UDFormValidationResult -Valid
                }
            } -OnSubmit {
                Sync-UDElement -Id dynComputerInformationExpansionPanelGroup
                $ComputerName = $EventData.txtComputerName
                Set-UDElement -Id elmComputerInformationExpansionPanelGroup -Content {
                    New-UDDynamic -Id dynComputerInformationExpansionPanelGroup -Content {
                        New-ComputerInformationExpansionPanelGroup -ComputerName $ComputerName
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
        New-UDElement -Id elmComputerInformationExpansionPanelGroup -Tag div
    }
}