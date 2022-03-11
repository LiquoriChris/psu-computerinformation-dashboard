function New-UDSyncButton {
    param (
        [string[]]$Id,
        [string]$Text = 'Refresh Data'
    )

    New-UDButton -Id "btn$Id" -Text $Text -Icon (New-UDIcon -Icon Sync) -OnClick {
        $Id |Foreach-Object {
            Sync-UDElement -Id $PSItem
        }
    } -Style @{
        height = '50px'
    }
}