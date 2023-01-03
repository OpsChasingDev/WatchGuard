<#
    - finish constructor
    - support string portion of semantic versioning (the "beta" part of "12.3.1-beta")
#>

function Download-WSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.SemanticVersion]$Version,

        [ValidatePattern('([0-9]|[A-Z])\.exe$')]
        [Parameter(HelpMessage = "Enter a full file path and name ending in .exe")]
        [string]$Path
    )

    # format version string
    $VersionString = [string]$Version.Major + "_" + [string]$Version.Minor
    if ($Version.Patch) {
        $VersionString = $VersionString + "_" + $Version.Patch
    }

    # set to current location if not specified
    if (!$Path) {
        $Path = (Get-Location).Path + "\wsm_$($VersionString).exe"
    }

    # download
    $Uri = "https://cdn.watchguard.com/SoftwareCenter/Files/WSM/$($VersionString)/wsm_$($VersionString).exe"
    try {
        Invoke-WebRequest -Uri $Uri -OutFile $Path -ErrorAction Stop -ErrorVariable DownloadError
    }
    catch {
        Write-Output $DownloadError
    }

    # output downloaded file path
    $DownloadPath = [PSCustomObject]@{
        Path = $Path
    }
    Write-Output $DownloadPath
}

function Install-WSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$Path
    )
    Start-Process $Path -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART' -Wait
}

do {
    [System.Management.Automation.SemanticVersion]$Version = Read-Host "Version to install (e.g. '12.9' or '11.8.3')"
} while (!$Version)

$Path = (Download-WSM -Version 12.9).Path
<#
do {
    $null = Test-Path $Path
} until ($Path)

if ($Path) {
    Install-WSM -Path $Path
}

Write-Output "Success"
#>