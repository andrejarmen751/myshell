if (Get-Alias -Name nano -ErrorAction SilentlyContinue) {
    Remove-Alias -Name nano
}
function global:nano ($File){
    $File = $File -replace “\\”, “/” -replace “ “, “\ “
    bash -c “nano $File”
    }
New-Alias -Name CLITextEditor -Value nano