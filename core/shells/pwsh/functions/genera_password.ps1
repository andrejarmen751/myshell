function EsNumeric ($valor){
    [string]$InString = $valor
    [Int32]$OutNumber = $null

 

    if ([Int32]::TryParse($InString,[ref]$OutNumber)){
        if ($OutNumbe -ge 1){
            return $OutNumber 
        } else {
            return 30
        }
    } else {
        return 30
    }
}

 

function Get-RandomCharacters($length, $characters) { 
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 
    $private:ofs="" 
    return [String]$characters[$random]
}

 

# confirmar arguments
if (($Args[0] -eq $null) -or ($Args[0] -eq "")) {
    $repeticions = 30
} else {
    $repeticions = EsNumeric($Args[0])
}

 

$val = 0
$password =""
Do { 
    $val++ 
    $QC = Get-RandomCharacters -length 1 -characters '1234'
    switch ($QC) {
        "1"  {
            $password += Get-RandomCharacters -length 1 -characters 'abcdefghijklmnopqrstuvwxyz'
            break
            }
        "2"  {$password += Get-RandomCharacters -length 1 -characters 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; break}
        "3"  {$password += Get-RandomCharacters -length 1 -characters '1234567890'; break}
        "4" {$password += Get-RandomCharacters -length 1 -characters '!"$%&/()=?}][{@#*+'; break}
        #default {$password += Get-RandomCharacters -length 1 -characters '!"§$%&/()=?}][{@#*+'; break}
    }
} while($val -ne $repeticions) 

 


echo $password