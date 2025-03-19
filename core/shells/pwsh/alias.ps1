if (Get-Alias -Name e -ErrorAction SilentlyContinue) {
    Remove-Alias -Name e
}
function global:e {
    if ($IsWindows) {
        & "\\wsl$\Debian\$project_path/core/shells/pwsh/history.ps1"
    } else {
        . "$project_path/core/shells/pwsh/history.ps1"
    }
    
    exit
}
New-Alias -Name ExitTerminal -Value e

if (Get-Alias -Name h -ErrorAction SilentlyContinue) {
    Remove-Alias -Name h
}
function global:h {
    Get-Content (Get-PSReadLineOption).HistorySavePath
}
New-Alias -Name CustomHistory -Value h


if (Get-Alias -Name oc -ErrorAction SilentlyContinue) {
    Remove-Alias -Name oc
}
function global:oc {
    C:\Users\storibio\oc\oc.exe
}
New-Alias -Name CustomOC -Value oc
