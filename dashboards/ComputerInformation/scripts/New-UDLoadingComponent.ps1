function New-UDLoadingComponent {
    [CmdletBinding()]
    param (
        [string]$Text,
        [string]$TextFontSize = 'h6',
        [string]$TextBackgroundColor = 'white'
    )

    Try {
        if ($Text) {
            $Params = @{
                Text = $Text
                Variant = $TextFontSize
                ErrorAction = 'Stop'
            }
            if ($TextBackgroundColor) {
                $Params.Style = @{
                    'background-color' = $TextBackgroundColor
                }
            }
            New-UDTypography @Params
        }
        New-UDProgress
    }
    Catch {
        throw $_
    }
}