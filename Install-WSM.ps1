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

function Download-WSM {
    [CmdletBinding()]
    param (
        [ValidatePattern('([0-9]|[A-Z])\.exe$')]
        [Parameter(HelpMessage = "Enter a full file path and name ending in .exe")]
        [string]$Path
    )
    $Version = Format-WSMVersion
    if (!$Path) {
        $Path = (Get-Location).Path + "\wsm_$($Version).exe"
    }
    $Uri = "https://cdn.watchguard.com/SoftwareCenter/Files/WSM/$($Version)/wsm_$($Version).exe"
    try {
        Invoke-WebRequest -Uri $Uri -OutFile $Path -ErrorAction Stop -ErrorVariable DownloadError
    }
    catch {
        Write-Output $DownloadError
    }
}

Download-WSM