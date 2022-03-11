function Get-MemoryInformation {
    <#
    .SYNOPSIS
        Get Memory information using CIM.
    .NOTES
        Class name: Win32_PhysicalMemory.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Memory = Get-CimInstance -CimSession $ComputerName -ClassName win32_PhysicalMemory -ErrorAction Stop
        $TotalMemory = ($Memory |Measure-Object -Property Capacity -Sum).Sum / 1gb
        $Memory |ForEach-Object {
            $Size = $PSItem.Capacity / 1gb
            $MemoryInformation = [ordered]@{
                Name = $PSItem.Name
                SerialNumber = $PSItem.SerialNumber
                Location = $PSItem.DeviceLocator
                TotalMemory = $TotalMemory
                Size = "$Size GB"
                Slots = if ($Memory.Name) {
                    $Memory.Name.Count
                }
            }
            [pscustomobject]$MemoryInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Memory" -Message $ErrorMessage -LogType Error
    }
}