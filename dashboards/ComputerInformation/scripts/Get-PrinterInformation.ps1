function Get-PrinterInformation {
    <#
    .SYNOPSIS
        Get Printer information using CIM.
    .NOTES
        Class name: Win32_Printer.
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Printer = Get-CimInstance -CimSession $ComputerName -ClassName win32_Printer -ErrorAction Stop
        $Printer |Foreach-Object {
            $PrinterInformation = [ordered]@{
                Name = $PSItem.Name
                Status = $PSItem.Status
            }
            [pscustomobject]$PrinterInformation
        }
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Printer" -Message $ErrorMessage -LogType Error
    }
}