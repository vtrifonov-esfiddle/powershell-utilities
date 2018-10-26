Param(  
    [Parameter(Mandatory=$true)]  
    [string] $publisher,
    [Parameter(Mandatory=$true)]
    [string] $product
)

function Test-IsProgramInstalled($registrykeyNode) {
    return Get-ItemProperty $registrykeyNode | Select-Object DisplayName, DisplayVersion, Publisher | Where-Object { $_.DisplayName -like "*$product*" -and $_.Publisher -eq "$publisher" }     
}

$isX64ProgramInstalled = Test-IsProgramInstalled HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
if ($isX64ProgramInstalled) {
    Write-Host "$product by $publisher is installed as 64bit program."
    return $true
}

$isX86ProgramInstalled = Test-IsProgramInstalled HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
if ($isX86ProgramInstalled) {
    Write-Host "$product by $publisher is installed as 32bit program."
    return $true
}

return $false