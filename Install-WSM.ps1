# Invoke-WebRequest -Uri https://cdn.watchguard.com/SoftwareCenter/Files/WSM/12_4_1/wsm_12_4_1.exe -OutFile "C:\wsm_12_9.exe"

function Format-WSMVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.SemanticVersion]$Version
    )
    $VersionString = [string]$Version.Major + "_" + [string]$Version.Minor
    if ($Version.Patch) {
        $VersionString = $VersionString + "_" + $Version.Patch
    }
    Write-Output $VersionString
}