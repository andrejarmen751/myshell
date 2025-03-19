# code $PROFILE
# VARIABLE DECLARATION
$global:distro="Debian"
$global:project_path="/Documents/myshell"
# Conditional
if ($IsWindows) {
    $global:wslHomePath = wsl -d $distro -e bash -c 'echo $HOME'
    $global:project_path="$wslHomePath"+"$project_path"
} else {
    $global:project_path="$HOME"+"$project_path"
}

# ENTRYPOINT
if ($IsWindows) {
    & "\\wsl$\$distro$project_path/core/shells/pwsh/pwshrc.ps1"
} else {
    . "$project_path/core/shells/pwsh/pwshrc.ps1"
}
