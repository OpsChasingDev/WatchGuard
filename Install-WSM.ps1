<#
    - finish constructor
    - support string portion of semantic versioning (the "beta" part of "12.3.1-beta")
#>

function Get-WSM {
    <#
    .SYNOPSIS
        Downloads a desired version of the Watchguard System Manager software.
    .DESCRIPTION
        Downloads a desired version of the Watchguard System Manager software.
    .NOTES
        Inteded use is being called from Deploy-WSM.
    .EXAMPLE
        Get-WSM -Version 12.8.2
        Downloads WSM version 12.8.2 to the current directory.
    #>
    
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

function Deploy-WSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            HelpMessage = "Enter a semantic-format version (e.g. 12.3.0 or 6.2-U3")]
        [System.Management.Automation.SemanticVersion]$Version
    )

    $Path = (Get-WSM -Version $Version).Path

    do {
        $null = Test-Path $Path
        Start-Sleep -Seconds 1
    } until ($Path)
    
    Install-WSM -Path $Path
    
    Write-Output "Success"
}