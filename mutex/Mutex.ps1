

<#
#ฬท๐   ๐๐ก๐ข ๐ข๐๐ก๐๐๐ฃ๐ค๐
#ฬท๐   ๐ตโโโโโ๐ดโโโโโ๐ผโโโโโ๐ชโโโโโ๐ทโโโโโ๐ธโโโโโ๐ญโโโโโ๐ชโโโโโ๐ฑโโโโโ๐ฑโโโโโ ๐ธโโโโโ๐จโโโโโ๐ทโโโโโ๐ฎโโโโโ๐ตโโโโโ๐นโโโโโ ๐งโโโโโ๐พโโโโโ ๐ฌโโโโโ๐บโโโโโ๐ฎโโโโโ๐ฑโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐บโโโโโ๐ฒโโโโโ๐ชโโโโโ๐ตโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐ณโโโโโ๐นโโโโโ๐ชโโโโโ.๐ถโโโโโ๐จโโโโโ@๐ฌโโโโโ๐ฒโโโโโ๐ฆโโโโโ๐ฎโโโโโ๐ฑโโโโโ.๐จโโโโโ๐ดโโโโโ๐ฒโโโโโ
#>





function New-Mutex {
<#
.SYNOPSIS
    Produces an array that when displayed to the console is shaped like a rectangle.
.PARAMETER Name
    Specifies the name of the Mutex to create/reference

#>
    [CmdletBinding(SupportsShouldProcess)] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    [bool] $createdMutex = $false
    $mutex = [System.Threading.Mutex]::new($true, $Name, [ref] $createdMutex)
    Write-Verbose "[New-Mutex] createdMutex $createdMutex"
    $mutex
}

function Wait-OnMutex 
{
    [CmdletBinding(SupportsShouldProcess)] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    Write-Verbose "[Test-OnMutex] start waiting for `"$Name`""
    try
    {
        $MutexInstance = [System.Threading.Mutex]::new($False, $Name)

        while (-not $MutexInstance.WaitOne(1000))
        {
            Start-Sleep -m 500;
        }
        Write-Verbose "[Test-OnMutex] stop waiting for `"$Name`""
        return $MutexInstance
    } 
    catch [System.Threading.AbandonedMutexException] 
    {
        $MutexInstance = [System.Threading.Mutex]::new($False, $Name)
        return Wait-OnMutex -Name $Name
    }
}

function Test-Mutex 
{
    [CmdletBinding(SupportsShouldProcess)] 
    param( 
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, HelpMessage="The name of the mutex")] 
        [string]$Name
    )
    Write-Verbose "Attempting to grab mutex $Name" 
    $sessionHandle = [System.Threading.Mutex]::new($False, $Name)
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

