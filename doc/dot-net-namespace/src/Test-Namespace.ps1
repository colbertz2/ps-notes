function Test-Namespace {
    <#
    .SYNOPSIS
    Tests whether .NET namespaces declared in a neighboring file are available to this function in the same folder.
    #>

    [char]$pass = 0x2713
    [char]$fail = 0x2717

    $n1 = "System.Management.Automation.Host"
    $n2 = "System.DirectoryServices.ActiveDirectory"

    try {
        $test = New-Object -TypeName ChoiceDescription "&Test"
        Write-Host "$pass Namespace found: $n1"
    } catch {
        Write-Host "$fail Namespace not found: $n1"
    }

    try {
        $test = New-Object -TypeName HourOfDay
        Write-Host "$pass Found namespace $n2"
    } catch {
        Write-Host "$fail Namespace not found: $n2"
    }
}