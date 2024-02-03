
#
# SweetAda GCC defines generator.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1     = output filename
# $2..$n = list of GCC macro define specifications
#
# Environment variables:
# CC
#

#
# <GCC_define>:<Ada_identifier>:<type>:<specifier>
#
# GCC_define: macro name
# Ada_identifier: Ada identifier name
# type: Ada type (empty = untyped)
# specifier:
#  B - Boolean (soft): True if defined, else False
#  H - Boolean (hard): True if defined and <> 0, else False
#  N - constant/Integer: value, else -1
#  P - constant/Integer: value if > 0, else -1
#  S - String: value, else ""
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

#
# Basic input parameters check.
#
$output_filename, $items = $args
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Host "${scriptname}: *** Error: no output filename specified."
  ExitWithCode 1
}
if ($items.length -lt 1)
{
  Write-Host "${scriptname}: *** Error: no items specified."
  ExitWithCode 1
}

$max_tmacro_length = 0
$max_type_length = "Boolean".length
foreach ($i in $items)
{
  $i_splitted = $i.Split(":")
  $macro  = $i_splitted[0]
  $tmacro = $i_splitted[1]
  $type   = $i_splitted[2]
  $spec   = $i_splitted[3]
  if ([string]::IsNullOrEmpty($macro) -or [string]::IsNullOrEmpty($tmacro))
  {
    Write-Host "${scriptname}: *** Error: no item definition."
    ExitWithCode 1
  }
  switch (${spec})
  {
    { ($_ -eq "B") -or ($_ -eq "H") -or ($_ -eq "N") -or ($_ -eq "P") -or ($_ -eq "S") }
      { }
    default
      {
        Write-Host "${scriptname}: *** Error: no item specifier."
        ExitWithCode 1
      }
  }
  if ($tmacro.length -gt $max_tmacro_length)
  {
    $max_tmacro_length = $tmacro.length
  }
  if ($type.length -gt $max_type_length)
  {
    $max_type_length = $type.length
  }
}
if ($max_type_length -gt 0)
{
  $max_type_length = $max_type_length + 1
}
$bseparator = " " * ($max_type_length - "Boolean".length)

$indent = "   "

$env_gcc = $(GetEnvVar "CC").Split(" ", 2)
$gcc = $env_gcc[0]
$gcc_args = $env_gcc[1]

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.CreateNoWindow = $true
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardInput = $true
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.FileName = $gcc
$pinfo.Arguments = "$gcc_args -E -P -dM -c -"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
try
{
  $p.Start() | Out-Null
  $stdin = $p.StandardInput
  $stdin.WriteLine("void ___(void) {}")
  if ($stdin)
  {
    $stdin.Close()
  }
  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  if ($p.ExitCode -ne 0)
  {
    Write-Host "${scriptname}: *** Error: executing ${gcc}."
    ExitWithCode $p.ExitCode
  }
}
catch
{
  Write-Host "${scriptname}: *** Error: executing ${gcc}."
  ExitWithCode 1
}

$lines = $stdout.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)

Remove-Item -Path $output_filename -Force -ErrorAction Ignore
New-Item -Name $output_filename -ItemType File | Out-Null

Add-Content -Path $output_filename -Value ""
Add-Content -Path $output_filename -Value "package GCC_Defines"
Add-Content -Path $output_filename -Value "$($indent)with Pure => True"
Add-Content -Path $output_filename -Value "$($indent)is"
Add-Content -Path $output_filename -Value ""
foreach ($i in $items)
{
  $i_splitted = $i.Split(":")
  $i_macro  = $i_splitted[0]
  $i_tmacro = $i_splitted[1]
  $i_type   = $i_splitted[2]
  $i_spec   = $i_splitted[3]
  $mseparator = " " * ($max_tmacro_length - $i_tmacro.length)
  $tseparator = " " * ($max_type_length - $i_type.length)
  #Add-Content -Path $output_filename -Value "$($indent)-- $($i_macro)"
  $found = ""
  foreach ($line in $lines)
  {
    $define = $line.Split(" ", 3)
    $macro = $define[1]
    $value = $define[2]
    if ($i_macro -eq $macro)
    {
      $found = "Y"
      switch ("${i_spec}${i_type}")
      {
        { $_ -eq "BBoolean" }
          { $value = "True" }
        { $_ -eq "HBoolean" }
          { if ($value -ne 0) { $value = "True" } else { $value = "False" } }
        { ($_ -eq "N") -or ($_ -eq "NInteger") }
          { if ([string]::IsNullOrEmpty($value)) { $value = "-1" } }
        { ($_ -eq "P") -or ($_ -eq "PInteger") }
          { if ([int]$value -lt 1) { $value = "-1" } }
        { $_ -eq "SString" }
          { if ([string]::IsNullOrEmpty($value)) { $value = "`"`"" } }
        default
          {
            Write-Host "${scriptname}: *** Error: inconsistent item specification."
            ExitWithCode 1
          }
      }
      break
    }
  }
  if ([string]::IsNullOrEmpty($found))
  {
    switch ("${i_spec}${i_type}")
    {
      { ($_ -eq "BBoolean") -or ($_ -eq "HBoolean") }
        { $value = "False" }
      { ($_ -eq "N") -or ($_ -eq "NInteger") -or ($_ -eq "P") -or ($_ -eq "PInteger") }
        { $value = "-1" }
      { $_ -eq "SString" }
        { $value = "`"`"" }
      default
      {
        Write-Host "${scriptname}: *** Error: inconsistent item specification."
        ExitWithCode 1
      }
    }
  }
  $declstring = "$($indent)$($i_tmacro)$($mseparator) : constant $($i_type)$($tseparator):= $($value);"
  Add-Content -Path $output_filename -Value "$($declstring)"
}

Add-Content -Path $output_filename -Value ""
Add-Content -Path $output_filename -Value "end GCC_Defines;"

Write-Host "${scriptname}: ${output_filename}: done."

ExitWithCode 0

