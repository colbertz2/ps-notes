# Source and export module functions
foreach ($item in $(Get-ChildItem "$PSScriptRoot\src")) { . $item.FullName }