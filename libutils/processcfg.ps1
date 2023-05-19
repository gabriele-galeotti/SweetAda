
#
# Process a configuration template file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
#
# Environment variables:
# SED
# every variable referenced in the input file
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name

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
# GetEnvVar()                                                                  #
#                                                                              #
################################################################################
function GetEnvVar
{
  param([string]$varname)
  if (-not (Test-Path env:$varname))
  {
    return $null
  }
  else
  {
    return (Get-Item env:$varname).Value.Trim("`"")
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$input_filename = $args[0]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}
$output_filename = $args[1]
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Host "${scriptname}: *** Error: no output file specified."
  ExitWithCode 1
}

$sed = (Get-Item env:SED).Value

$symbols = Select-String -Pattern "@[_A-Za-z][_A-Za-z0-9]*@" $input_filename | `
  foreach {$_.Matches} | Select-Object -ExpandProperty Value

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.CreateNoWindow = $true
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.FileName = "$sed"
$pinfo.Arguments = ""
if ($symbols.Count -gt 0)
{
  foreach ($symbol in $symbols)
  {
    $variable = $symbol.Trim("@")
    $value = $(GetEnvVar $variable)
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
}
else
{
  $pinfo.Arguments += " -e"
  $pinfo.Arguments += " `"`""
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
    Write-Host "${scriptname}: *** Error: executing ${sed}."
    ExitWithCode $p.ExitCode
  }
}
catch
{
  Write-Host "${scriptname}: *** Error: executing ${sed}."
  ExitWithCode 1
}
Set-Content -Path $output_filename -Value $stdout -NoNewLine -Force

Write-Host "${scriptname}: ${output_filename}: done."

ExitWithCode 0

