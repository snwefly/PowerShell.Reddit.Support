

[CmdletBinding(SupportsShouldProcess)] 
param( 
    [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
    [string]$Name
)


. "$PSScriptRoot\Mutex.ps1"


Write-Host "Waiting for script A to terminate..."

[System.Threading.Mutex]$mutant = Wait-OnMutex -Name "$Name"
 
Write-Host "Script A terminated!" -f Green

$mutant.ReleaseMutex(); 
$mutant.Dispose();