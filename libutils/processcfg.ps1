
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
# Write-Stderr()                                                               #
#                                                                              #
################################################################################
function Write-Stderr
{
  param([PSObject]$inputobject)
  $outf = if ($host.Name -eq "ConsoleHost")
  {
    [Console]::Error.WriteLine
  }
  else
  {
    $host.UI.WriteErrorLine
  }
  if ($inputobject)
  {
    [void]$outf.Invoke($inputobject.ToString())
  }
  else
  {
    [string[]]$lines = @()
    $input | % { $lines += $_.ToString() }
    [void]$outf.Invoke($lines -join "`r`n")
  }
}

################################################################################
# GetEnvVar()                                                                  #
#                                                                              #
################################################################################

$GetEnvironmentVariable_signature = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern uint
GetEnvironmentVariable(
  string                    lpName,
  System.Text.StringBuilder lpBuffer,
  uint                      nSize
  );
'@
Add-Type                                              `
  -MemberDefinition $GetEnvironmentVariable_signature `
  -Name "Win32GetEnvironmentVariable"                 `
  -Namespace Win32

$gev_buffer_size = 4096
$gev_buffer = [System.Text.StringBuilder]::new($gev_buffer_size)

function GetEnvVar
{
  param([string]$varname)
  if (-not (Test-Path env:$varname))
  {
    return [string]::Empty
  }
  else
  {
    $nchars = [Win32.Win32GetEnvironmentVariable]::GetEnvironmentVariable(
                $varname,
                $gev_buffer,
                [uint32]$gev_buffer_size
                )
    if ($nchars -gt $gev_buffer_size)
    {
      Write-Stderr "$($scriptname): *** Error: GetEnvVar: buffer size < $($nchars)."
      ExitWithCode 1
    }
    return [string]$gev_buffer
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
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$output_filename = $args[$argc + 1]
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Stderr "$($scriptname): *** Error: no output file specified."
  ExitWithCode 1
}

$nl = [Environment]::NewLine

try
{
  $textlines = [System.IO.File]::ReadAllText($input_filename).Split($nl)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: processing $($input_filename)."
  ExitWithCode 1
}

[string]$stdout = ""
[int]$count = 0
$textlines | ForEach-Object `
{
  $count = $count + 1
  $textline = $_
  $symbols = $textline | Select-String -Pattern "@-?[_A-Za-z][_A-Za-z0-9]*@" -AllMatches | `
    foreach {$_.Matches} | Select-Object -ExpandProperty Value
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
        Write-Stderr "*** Warning: variable `"$variable`" has no value."
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
    $textline = $textline -Replace "$symbol","$value"
  }
  if ($count -lt $textlines.Count)
  {
    $stdout = "$($stdout)$($textline)$($nl)"
  }
  else
  {
    $stdout = "$($stdout)$($textline)"
  }
}

if ($remove_cr)
{
  $stdout = $stdout | ForEach-Object {$_ -Replace "`r",""}
}
Set-Content -Path $output_filename -Value $stdout -NoNewLine -Force

Write-Host "$($scriptname): $($output_filename): done."

ExitWithCode 0

