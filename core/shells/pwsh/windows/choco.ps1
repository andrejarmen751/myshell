if (Test-Path "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1") {
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}