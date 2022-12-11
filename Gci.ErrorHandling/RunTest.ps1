
<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>

[CmdletBinding(SupportsShouldProcess)]
param ()

function Get-TestPaths{

    $RootPath = Join-Path "$ENV:Temp" "TestGciErrors"

    # create 3 normal sub directories
    $NormalPath = Join-Path "$RootPath" "Normal"
    $childs = @('child_1', 'child_2', 'child_3')
    ForEach($c in $childs){
        $childpath = Join-Path $NormalPath $c
        $Null = New-Item -Path $childpath -ItemType directory -Force -ea Ignore
    }

    #Create accessErrorpath
    $accessErrorpath = Join-Path $RootPath "NotReadable"

    if(-not(Test-Path $accessErrorpath)){
        $Null = New-Item -Path $accessErrorpath -ItemType directory -Force -ea Ignore

        # Remove read access to this path
        $ACL = Get-Acl -Path $accessErrorpath
        $ACL.SetAccessRuleProtection($true,$false)
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$ENV:USERDOMAIN\$ENV:USERNAME","Read","Allow")
        $ACL.RemoveAccessRule($AccessRule)
        $ACL | Set-Acl -Path $accessErrorpath
    }
    $notExistentChildpath = Join-Path $RootPath "NonExistant"

    $Return = @($NormalPath, $notExistentChildpath,$accessErrorpath)
    $Return 
}



function Test-GciErrorHandling{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [Alias('p', 'f','File')]
        [string[]]$Paths
    )
    
    $Childs = gci -Path $Paths  -ErrorVariable GciErrVar -ErrorAction silent

    $GciErrorsCounts = $GciErrVar.Count
    if($GciErrorsCounts -gt 0){
        $GciErrVar | % {
            $ExceptMsg=("[{0}]`n{1}" -f $_.TargetObject,$_.CategoryInfo.ToString())
            Write-Host "[Get-ChilItems Error] -> " -NoNewLine -ForegroundColor DarkRed; 
            Write-Host "$ExceptMsg`n`n" -ForegroundColor DarkYellow
        }
    }

    $Childs.Fullname
}

Write-Verbose "Getting Test Paths..."
$TestPaths = Get-TestPaths

ForEach($fn in $TestPaths) {
    Write-Verbose " - $fn"
}

Test-GciErrorHandling $TestPaths