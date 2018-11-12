#===========================================================================
# Gathers the XAML file
#===========================================================================
$inputXML = @"
<XAMLCODE>
"@
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $mainForm=[Windows.Markup.XamlReader]::Load($reader)
}catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])"
}
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | ForEach-Object{ Set-Variable -Name "WPF_$($_.Name)" -Value $mainForm.FindName($_.Name) -ErrorAction Stop}
#===========================================================================
# Uses this to get the variables that are loaded into the script from the XAML
Function Get-FormVariables{
  write-host "Found the following objects:"
  get-variable WPF_*
}
# Get-FormVariables
#===========================================================================

# Marks the form as active
[void]$Mainform.Activate()
# Brings the form into focus
[void]$Mainform.Focus()
# Shows The form
[void]$Mainform.ShowDialog()
