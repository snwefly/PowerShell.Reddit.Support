<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>

# Based on the code at https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-a-custom-input-box?view=powershell-7.2

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$LogPath = "$PSScriptRoot\dep\log.ps1"
$AlgoPath = "$PSScriptRoot\dep\crypto.ps1"

Write-Host "Including $LogPath"
. "$LogPath"
Write-Host "Including $AlgoPath"
. "$AlgoPath"

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,220)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,140)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,140)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$labelIn = New-Object System.Windows.Forms.Label
$labelIn.Location = New-Object System.Drawing.Point(10,20)
$labelIn.Size = New-Object System.Drawing.Size(280,20)
$labelIn.Text = 'Please enter the information in the space below:'
$form.Controls.Add($labelIn)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10,100)
$outputBox.Size = New-Object System.Drawing.Size(260,20)
$outputBox.Enabled = $false
$form.Controls.Add($outputBox)

$labelOut = New-Object System.Windows.Forms.Label
$labelOut.Location = New-Object System.Drawing.Point(10,80)
$labelOut.Size = New-Object System.Drawing.Size(280,20)
$labelOut.Text = 'Result string below:'
$form.Controls.Add($labelOut)


$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})

$okButton.Add_Click({ 
    $x = Encrypt -String $textBox.Text
    $outputBox.Text = $x
    $x
})


$result = $form.ShowDialog()
