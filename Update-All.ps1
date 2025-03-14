[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Install script called at console")]
<#
    .SYNOPSIS
    Install the VcRedist module and all supported VcRedists on the local system.

    .DESCRIPTION
    Installs the VcRedist PowerShell module and installs the default Microsoft Visual C++ Redistributables on the local system.

    .NOTES
    Copyright 2023, Aaron Parker, stealthpuppy.com
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [System.String] $Path = "$env:Temp\VcRedist-Files"
)

try {
    Import-Module VcRedist
} CATCH {
    STart-Process Powershell.exe -args '-Command "Iwr -uri `"https://raw.githubusercontent.com/eitgrp/vcredist/refs/heads/main/Install-VCRedist.ps1`" | Iex"' -wait
    Import-Module-VcRedist
}

#region tasks/install apps
Write-Host "Saving VcRedists to path: $Path."
New-Item -Path $Path -ItemType "Directory" -Force -ErrorAction "SilentlyContinue" > $null

Write-Host "Downloading and installing supported Microsoft Visual C++ Redistributables."
$Redists = Get-VcList | Save-VcRedist -Path $Path | Install-VcRedist -Silent

Write-Host "Installed Visual C++ Redistributables:"
$Redists | Select-Object -Property "Name", "Release", "Architecture", "Version" -Unique
#endregion
