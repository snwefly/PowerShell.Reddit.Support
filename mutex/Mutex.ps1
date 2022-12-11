

<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>





function New-Mutex {
<#
.SYNOPSIS
    Produces an array that when displayed to the console is shaped like a rectangle.
.PARAMETER Name
    Specifies the name of the Mutex to create/reference

#>
    [CmdletBinding()] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    [bool] $createdMutex = $false
    $mutex = New-Object System.Threading.Mutex($true, $Name, [ref] $createdMutex)
    $mutex
}

function Wait-Mutex 
{
    [CmdletBinding()] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    while(-not (Test-Mutex -Name $Name)){
        Start-Sleep -Milliseconds 200
    }

}

function Test-Mutex 
{
    [CmdletBinding()] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    Write-Verbose "Attempting to grab mutex $Name" 
    $sessionHandle = New-Object System.Threading.Mutex $false, $Name
    $isAvailable = $false

    try
    {
        $isAvailable = $sessionHandle.WaitOne(1000)
    }
    catch [System.Threading.AbandonedMutexException]
    {
        $isAvailable = $true
    }

    $isAvailable
}

