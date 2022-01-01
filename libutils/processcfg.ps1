
#
# Process a configuration template file.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
#
# Environment variables:
# every variable referenced in the input file
#

################################################################################
# ExitWithCode()                                                               #
#                                                                              #
################################################################################
function ExitWithCode
{
  param($exitcode)
  $host.SetShouldExit($exitcode)
  exit $exitcode
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name

$input_filename = $args[0]
$output_filename = $args[1]

$symbols = Select-String -Pattern "@[_A-Za-z][_A-Za-z0-9]*@" $input_filename | `
  ForEach {$_.Matches} | Select-Object -ExpandProperty Value

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.CreateNoWindow = $true
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.FileName = "sed.exe"
$pinfo.Arguments = ""
foreach ($symbol in $symbols)
{
  $variable = $symbol.Trim("@")
  $value = (Get-Item env:$variable).Value.Trim("`"")
  if ($value -eq $null)
  {
    Write-Host "*** Warning: variable `"$variable`" has no value."
  }
  else
  {
    $pinfo.Arguments += " -e"
    $pinfo.Arguments += " `"s|$symbol|$value|`""
  }
}
$pinfo.Arguments += " $input_filename"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
try
{
  $p.Start() | Out-Null
  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  if ($p.ExitCode -ne 0)
  {
    Write-Host "${scriptname}: *** Error: executing sed.exe."
    ExitWithCode $p.ExitCode
  }
}
catch
{
  Write-Host "${scriptname}: *** Error: executing sed.exe."
  ExitWithCode 1
}

Set-Content -Path $output_filename -Value $stdout -NoNewLine -Force

Write-Host "${scriptname}: ${output_filename}: done."

ExitWithCode 0

