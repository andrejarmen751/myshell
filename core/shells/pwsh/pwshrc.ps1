Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Import-Module PSReadLine
if ($IsWindows) {
    & "\\wsl$\Debian\$project_path/core/shells/pwsh/alias.ps1"
    & "\\wsl$\Debian\$project_path/core/shells/pwsh/windows/choco.ps1"
    & "\\wsl$\Debian\$project_path/core/shells/pwsh/windows/wsl.ps1"
    & "\\wsl$\Debian\$project_path/core/shells/pwsh/windows/nano.ps1"
    & "\\wsl$\Debian\$project_path/core/shells/pwsh/windows/genera_password.ps1"
    Set-PSReadLineOption -HistorySavePath "\\wsl$\Debian\$project_path/core/shells/pwsh/HistoryFile.txt"
} else {
    . "$project_path/core/shells/pwsh/alias.ps1"
    Set-PSReadLineOption -HistorySavePath "$project_path/core/shells/pwsh/HistoryFile.txt"
}