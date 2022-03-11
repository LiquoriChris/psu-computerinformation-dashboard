# PowerShell Universal Computer Information Dashboard

This dashboard will get computer related information using PowerShell CIM Cmdlets, run remote commands, restart and shutdown remote computers.

The dashboard requires a number of configuration changes to be made before starting the dashboard. After importing the template, open the `Configuration.json` file and change the following settings:

* AD Properties: Properties used when query Active Directory for domain computer information. `Get-ADComputer -Properties <Properties>`
* OrganizationalUnit: This is the organizational unit used to load computers into the auto-complete list. The `Get-ADComputer` Cmdlet is used and searches for `Enabled` computers and all child OUs. 
* RestrictedGroup (Optional): Add one or more AD groups to restrict the dashboard from sending remote commands, restart, or shutdown commands to the selected computer.
* Licensed Application: List of one or more applications that searches `C:\Program Files` and `C:\Program Files (x86)` directories for `.exe` and the last accessed date. This is helpful when licensing renewals are approaches and need to find if a user has been using a licensed application.
* DashboardName: Name of the dashboard. This will also serve as the log path for all infomational and error logging. The default log path is set to `C:\ProgramData\PowerShellUniversal\logs\<DashboardName>`
* UPNDomainSuffix (Optional): This is used if the dashboard will search for Intune devices via UserName/UserPrincipalName.
* InternalDomainName: Used when querying NetConnectionProfiles. This will tell if any net adapters are connected to a domain autenticated network.

## Searching Intune Devices

To enable searching Intune devices via username, open the two scripts under the `pages` directory and add `-SearchIntuneDevice` parameter. This will add a button to `New-ComputerInformationScanForm.ps1` and `New-ComputerInformationForm.ps1` to search Intune.

**Note: This will require a credential to login to Intune using the MSOnline PowerShell module**

## Logging

All logs (Informational/Error) will go under `C:\ProgramData\PowerShellUniversal\logs\<DashboardName>`. This is helpful when troubleshooting errors or view history of remote commands being run.

## Remote Commands

All remote commands are logged (See above), timestamped, and includes the user that execute the command. A `History` button will appear if the log path contains the computer and date timestamp log file, this will be sort by latest date.