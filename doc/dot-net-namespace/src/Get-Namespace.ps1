using namespace System.Management.Automation.Host
using namespace System.DirectoryServices.ActiveDirectory

function Get-Namespace {
    <#
    .SYNOPSIS
    Returns 0

    .DESCRIPTION
    Declares the following .NET namespaces:

    System.Management.Automation.Host
    System.DirectoryServices.ActiveDirectory

    Doesn't do anything with these namespaces. Just returns 0.
    #>

    return 0
}