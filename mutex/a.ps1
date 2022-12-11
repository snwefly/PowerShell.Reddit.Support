
. "$PSScriptRoot\Mutex.ps1"

[System.Threading.Mutex]$mutant;

 # Obtain a system mutex that prevents more than one deployment taking place at the same time.
[bool]$wasCreated = $false;
$mutant = New-Mutex -Name "M"

$StartTime = [DateTime]::Now
$StopTime = $StartTime.AddSeconds(20)
Write-Host "Running." -n
While($StopTime -gt [DateTime]::Now){
     Start-Sleep 1
    Write-Host " ." -n
}
Write-Host "`nStopped." 
    
$mutant.ReleaseMutex(); 
$mutant.Dispose();    