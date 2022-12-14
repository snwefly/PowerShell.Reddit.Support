


<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>

function Copy-FromFile { 
<# 
    .SYNOPSIS 
    copy files listed in a text file to a specific folder, while preserving folder structure

    .DESCRIPTION 
    copy files listed in a text file to a specific folder, while preserving folder structure 
    It outputs the list of copied files

    .OUTPUTS
    Returns a list of copied files
#> 
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [String]$Destination,
        [Parameter(Mandatory=$true,Position=1)]
        [String]$File,
        [Parameter(Mandatory=$false)]
        [switch]$Overwrite,
        [Parameter(Mandatory=$false)]
        [switch]$SilentErrors
    )

    try{
        if(-not(Test-Path -Path $File -PathType Leaf)){throw "No such file $File"}

        if($Overwrite){
            Remove-Item -Path $Destination -Recurse | Out-Null
            New-Item -Path $Destination -ItemType directory -Force -ErrorAction Ignore | Out-Null
        }
        if( ((Test-Path -Path $Destination -PathType Container) -eq $True) -And ((gci $Destination -ErrorAction Ignore).Count -gt 0) ){
            throw "Directory $Destination exists and is not empty. Consider using -Overwrite argument"
        }
        $Results = [System.Collections.ArrayList]::new()
        # Force the file paths in a [string[]] Array variable
        [string[]]$FilesToCopy = Get-Content $File
        ForEaCH($file in $FilesToCopy){
            $split = Split-Path $file -NoQualifier
            $NewFilePath = Join-Path $Destination $split 
            
            Write-Verbose "Copy $file to `"$NewFilePath`""
            # Store the Copy-Item Errors in the $CopyErrors variable for later processing   
            $Parent =  Split-Path "$NewFilePath"
            if(Test-Path -Path $file -PathType Leaf){ 
                New-Item -Path $Parent -ItemType directory -Force -ErrorAction Ignore | Out-Null
            }
            $Copied = Copy-Item "$file" -Destination "$NewFilePath" -Force  -ErrorVariable CopyErrors -ErrorAction silent -Passthru
            [void]$Results.Add($Copied.Fullname)
            if($PSBoundParameters.ContainsKey('SilentErrors') -eq $False){
                $CopyErrors | % {
                    $ExceptMsg=("[{0}]`n{1}" -f $_.TargetObject,$_.CategoryInfo.ToString())
                    Write-Host "[Copy-Item Error] -> " -NoNewLine -ForegroundColor DarkRed; 
                    Write-Host "$ExceptMsg" -ForegroundColor DarkYellow
                }
            }
        }
        $Results
    }catch{
        Write-Error $_
    }

}