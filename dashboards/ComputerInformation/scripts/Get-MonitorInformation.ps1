function Get-MonitorInformation {
    <#
    .SYNOPSIS
        Get Monitor information using CIM.
    .NOTES
        Class name: Win32_WmiMonitorID, WmiMonitorBasicDisplayParams.
        Namespace: root/WMI
    #>
    [CmdletBinding()]
    param (
        [string]$ComputerName
    )

    Try {
        $Monitor = Get-CimInstance -CimSession $ComputerName -ClassName WmiMonitorID -Namespace root/WMI -ErrorAction Stop
        $MonitorSize = Get-CimInstance -CimSession $ComputerName -Namespace root\wmi -Class WmiMonitorBasicDisplayParams |Select-Object InstanceName,@{
            Name = 'Size'
            Expression = {[System.Math]::Round(([System.Math]::Sqrt([System.Math]::Pow($_.MaxHorizontalImageSize, 2) + [System.Math]::Pow($_.MaxVerticalImageSize, 2))/2.54),2)} 
        }
        $Object = $Monitor |Foreach-Object {
            $Manufacturer = switch (-join $PSItem.ManufacturerName.ForEach({[char]$_})) {
                SAM {'Samsung'}
                DEL {'Dell'}
                default {'NCP'}
            }
            $InstanceName = $PSItem.InstanceName
            $Model = -join $PSItem.UserFriendlyName.ForEach({[char]$_})
            $SerialNumber = -join $PSItem.SerialNumberID.ForEach({[char]$_})
            $MonitorSize |Foreach-Object {
                $Size = $PSItem |Where-Object {$_.InstanceName -eq $InstanceName}
                [pscustomobject]@{
                    Manufacturer = $Manufacturer
                    Model = if ($Manufacturer -eq 'NCP') {
                        $Model = 'Generic PnP Monitor'
                        $Model
                    }
                    else {
                        $Model
                    }
                    SerialNumber = $SerialNumber
                    Size = $Size.Size
                }
            }
        }
        $Object |Where-Object Size
    }
    Catch {
        $ErrorMessage = $_
        Write-Warning $ErrorMessage
        Write-Log -FolderName "$DashboardName\Monitor" -Message $ErrorMessage -LogType Error
    }
}