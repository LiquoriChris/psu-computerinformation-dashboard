$ConfigurationPath = Get-Content -Path (Join-Path $PSScriptRoot -ChildPath configuration.json)
$global:Configuration = $ConfigurationPath |ConvertFrom-Json
$global:DashboardName = $Configuration.DashboardName
$ScriptPath = Join-Path -Path $PSScriptRoot -ChildPath scripts
Get-ChildItem -Path $ScriptPath -File |ForEach-Object {
    . $_.FullName
}
$global:Navigation = @(
    New-UDListItem -Label 'Computer Scan' -Icon (New-UDIcon -Icon compass) -OnClick {
        Invoke-UDRedirect '/computerscan' -OpenInNewWindow
    }
    New-UDListItem -Label 'Computer Information' -Icon (New-UDIcon -Icon desktop) -OnClick {
        Invoke-UDRedirect '/computerinformation' -OpenInNewWindow
    }
)

$Pages = New-Object System.Collections.Generic.List[hashtable]
Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath 'pages') |ForEach-Object {
    $Pages.Add((. $PSItem.FullName))
}
$DashboardParams = @{
    Title = $DashboardName
    Pages = $Pages
}
New-UDDashboard @DashboardParams