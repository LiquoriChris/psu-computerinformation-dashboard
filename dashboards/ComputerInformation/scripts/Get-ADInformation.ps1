function Get-ADInformation {
    <#
    .SYNOPSIS
        Gets Active Directory Computer object information

    .NOTES
        Properties are retrived from the Configuration.json file. To add more properties to the table, add the property to the Configuration.json and to the hashtable.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $ADComputer = Get-ADComputer -Filter "name -eq '$ComputerName'" -Properties $Configuration.AD.Computer.Properties
        $ADComputerInformation = [ordered]@{
            AllowReversiblePasswordEncryption = $ADComputer.AllowReversiblePasswordEncryption
            BadLogonCount = $ADComputer.BadLogonCount
            Changed = Get-Date -Date $ADComputer.WhenChanged -Format g
            Created = Get-Date -Date $ADComputer.WhenCreated -Format g
            DistinguishedName = $ADComputer.DistinguishedName
            DnsHostName = $ADComputer.DnsHostName
            Enabled = $ADComputer.Enabled
            Guid = $ADComputer.ObjectGUID
            LastBadPasswordAttempt = $ADComputer.LastBadPasswordAttempt
            LastLogonDate = Get-Date -Date $ADComputer.LastLogonDate -Format g
            Name = $ADComputer.Name
            SamAccountName = $ADComputer.SamAccountName
        }
        [pscustomobject]$ADComputerInformation
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\ActiveDirectory" -Message $ErrorMessage -LogType Error
    }
}