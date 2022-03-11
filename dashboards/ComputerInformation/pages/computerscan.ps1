New-UDPage -Name 'Computer Scan' -DefaultHomePage -Url '/computerscan' -Navigation $Navigation -Content {
    New-ComputerInformationScanForm
}