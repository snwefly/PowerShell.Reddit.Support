


. "$PSScriptRoot\Mutex.ps1"

[System.Threading.Mutex]$mutant;

$ready = $False
Write-Host "Waiting for script A to terminate..."

$mutant = Wait-Mutex -Name "M"
Write-Host "Script A terminated!" -f Green

$mutant.ReleaseMutex(); 
$mutant.Dispose();