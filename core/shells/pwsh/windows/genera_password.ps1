if (Get-Alias -Name genera_password -ErrorAction SilentlyContinue) {
    Remove-Alias -Name genera_password
}
function global:genera_password {
    wsl -d Debian pwsh $project_path/core/shells/pwsh/functions/genera_password.ps1
}
New-Alias -Name Genera_password -Value genera_password