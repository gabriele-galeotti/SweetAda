
#
# Process a configuration template file.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional starting "-r" = remove CR from processed text
# $1 = input filename
# $2 = output filename
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
    return [string]::Empty
  }
  else
  {
    return (Get-Item env:$varname).Value
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

[int]$argc = 0
[bool]$remove_cr = $false

#
# Basic input parameters check.
#
if ([string]$args[$argc] -eq "-r")
{
  $remove_cr = $true
  $argc = $argc + 1
}
$input_filename = $args[$argc]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}
$output_filename = $args[$argc + 1]
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Host "${scriptname}: *** Error: no output file specified."
  ExitWithCode 1
}

$sed = (Get-Item env:SED).Value

$symbols = Select-String -Pattern "@-?[_A-Za-z][_A-Za-z0-9]*@" $input_filename | `
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
    $optional = $false
    if ($variable.StartsWith("-"))
    {
      $variable = $variable.TrimStart("-")
      $optional = $true
    }
    $value = $(GetEnvVar $variable)
    if ($value -eq [string]::Empty)
    {
      if (-not $optional)
      {
        Write-Host "*** Warning: variable `"$variable`" has no value."
      }
    }
    if ($value.StartsWith("`"") -and $value.EndsWith("`""))
    {
      $stringvalue = $value.Trim("`"")
      $value = $stringvalue
    }
    elseif ($value.StartsWith("0x"))
    {
      $hexvalue = $value.Substring(2)
      $value = "16#$hexvalue#"
    }
    $pinfo.Arguments += " -e"
    $pinfo.Arguments += " `"s|$symbol|$value|`""
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

if ($remove_cr)
{
  $stdout = $stdout | ForEach-Object {$_ -Replace "`r",""}
}
Set-Content -Path $output_filename -Value $stdout -NoNewLine -Force

Write-Host "${scriptname}: ${output_filename}: done."

ExitWithCode 0

