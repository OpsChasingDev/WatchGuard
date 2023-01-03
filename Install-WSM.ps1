# Invoke-WebRequest -Uri https://cdn.watchguard.com/SoftwareCenter/Files/WSM/12_4_1/wsm_12_4_1.exe -OutFile "C:\wsm_12_9.exe"

function Format-WSMVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.SemanticVersion]$Version
    )


    $obj = [PSCustomObject]@{
        Major = $Major
        Minor = $Minor
        Patch = $Patch
    }
    
    Write-Output $obj
}