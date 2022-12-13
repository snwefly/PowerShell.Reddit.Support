
[CmdletBinding(SupportsShouldProcess)] 
param( 
    [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
    [string]$Name
)

. "$PSScriptRoot\Mutex.ps1"


Function DoWorkSon([int]$WaitFor){
    Write-Host "`n[Starting Work] " -f DarkCyan -n 
    For($i = $WaitFor ; $i -gt 0 ; $i-- ){
        Start-Sleep 1
        Write-Host "." -n
    }
    Write-Host "`n[Stopped]" -f DarkCyan
}


[bool]$wasCreated = $False
[System.Threading.Mutex]$mutant = [System.Threading.Mutex]::new($True, $Name, [ref]$wasCreated)
if($wasCreated){
    Write-Verbose "Mutex Created `"$Name`""
    DoWorkSon(20)

    $mutant.ReleaseMutex(); 
    $mutant.Dispose();
    Write-Verbose "Mutex Disposed `"$Name`""
        
}
