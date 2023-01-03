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

$Version = Format-WSMVersion
$Uri = "https://cdn.watchguard.com/SoftwareCenter/Files/WSM/$($Version)/wsm_$($Version).exe"
Invoke-WebRequest -Uri $Uri -OutFile "C:\wsm_12_9.exe"