function New-ComputerInformationExpansionPanelGroup {
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )
    
    New-UDExpansionPanelGroup -Content {
        $Params = @{
            ComputerName = $ComputerName
        }
        New-ComputerInformationExpansionPanel @Params -Name ActiveDirectory -Script Get-ADInformation -ColumnName AllowReversiblePasswordEncryption, BadLogonCount, Changed, Created, DistinguishedName, DnsHostName, Enabled, Guid, LastLogonDate, Name, SamAccountName    
        New-ComputerInformationExpansionPanel @Params -Name AOVPN -Script Get-AOVPNInformation -ColumnName Name, Status, ServerAddress
        New-ComputerInformationExpansionPanel @Params -Name Battery -Script Get-BatteryInformation -ColumnName Name, DeviceID, Status, ChargeRemaining, RunTimeRemaining
        New-ComputerInformationExpansionPanel @Params -Name BIOS -Script Get-BIOSInformation -ColumnName Date, Name, Manufacturer, SerialNumber, Firmware
        New-ComputerInformationExpansionPanel @Params -Name Bitlocker -Script Get-BitlockerInformation -ColumnName Drive, EncryptionStatus
        New-ComputerInformationExpansionPanel @Params -Name ComputerSystem -Script Get-ComputerSystemInformation -ColumnName Name, Model, State, User
        New-ComputerInformationExpansionPanel @Params -Name CPU -Script Get-CPUInformation -ColumnName Name, Core, Processor, Speed
        New-ComputerInformationExpansionPanel @Params -Name Disk -Script Get-DiskDriveInformation -ColumnName Name, Status, Size, Partitions, Model, SerialNumber
        New-ComputerInformationExpansionPanel @Params -Name Memory -Script Get-MemoryInformation -ColumnName Name, SerialNumber, Location, Size
        New-ComputerInformationExpansionPanel @Params -Name Monitor -Script Get-MonitorInformation -ColumnName Manufacturer,Model, SerialNumber, Size
        New-ComputerInformationExpansionPanel @Params -Name NetAdapter -Script Get-NetAdapterInformation -ColumnName Name, InterfaceDescription, Status, MacAddress
        New-ComputerInformationExpansionPanel @Params -Name NetConnectionProfile -Script Get-NetConnectionProfileInformation -ColumnName Name, InterfaceAlias, NetworkCategory
        New-ComputerInformationExpansionPanel @Params -Name OperatingSystem -Script Get-OperatingSystemInformation -ColumnName Name, Version, Build, LastRestart
        New-ComputerInformationExpansionPanel @Params -Name PowerPlan -Script Get-PowerPlanInformation -ColumnName Name, Description, Active
        New-ComputerInformationExpansionPanel @Params -Name Printer -Script Get-PrinterInformation -ColumnName Name, Status
        New-ComputerInformationExpansionPanel @Params -Name SecurityUpdate -Script Get-SecurityUpdateInformation -ColumnName Name, KB, Installed
        New-ComputerInformationExpansionPanel @Params -Name Software -Script Get-SoftwareInformation -ColumnName Name, Version, Installed -ShowSearch
        New-ComputerInformationExpansionPanel @Params -Name Storage -Script Get-StorageInformation -ColumnName DriveLetter, DriveType, FileSystemType, Status, TotalSize, SizeRemaining
        New-ComputerInformationExpansionPanel @Params -Name Video -Script Get-VideoInformation -ColumnName Name, Status, DeviceID, VideoProcessor, DriverDate, DriverVersion
    }
}