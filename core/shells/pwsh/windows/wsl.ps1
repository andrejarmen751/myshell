if (Get-Alias -Name ubuntu -ErrorAction SilentlyContinue) {
    Remove-Alias -Name ubuntu
}
function global:ubuntu {
    Invoke-command -ScriptBlock {wt -w 0 nt -p "Ubuntu"}
    }
    
New-Alias -Name CustomUbuntuDistro -Value ubuntu

if (Get-Alias -Name debian -ErrorAction SilentlyContinue) {
    Remove-Alias -Name debian
}
function global:debian {
    Invoke-command -ScriptBlock {wt -w 0 nt -p "Debian"}
    }
    
New-Alias -Name CustomDebianDistro -Value debian

if (Get-Alias -Name fedora -ErrorAction SilentlyContinue) {
    Remove-Alias -Name fedora
}
function global:fedora {
    Invoke-command -ScriptBlock {wt -w 0 nt -p "Fedora"}
    }
    
New-Alias -Name CustomFedoraDistro -Value fedora