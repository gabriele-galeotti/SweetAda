
#
# SweetAda GCC defines generator.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1     = package name
# $2     = output filename
# $3..$n = list of GCC macro define specifications
#
# Environment variables:
# TOOLCHAIN_CC
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
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
#  U - String (unquoted): quoted value, else ""
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name
$nl = [Environment]::NewLine

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
    [void]$outf.Invoke($lines -Join $nl)
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
  string lpName,
  System.Text.StringBuilder lpBuffer,
  uint nSize
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
  if (-not (Test-Path Env:$varname))
  {
    return [string]::Empty
  }
  else
  {
    if ([System.Environment]::OSVersion.Platform -eq "Win32NT")
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
    else
    {
      return [string][Environment]::GetEnvironmentVariable(${varname})
    }
  }
}

################################################################################
# ConvertHex()                                                                 #
#                                                                              #
################################################################################
function ConvertHex
{
  param($inputvalue)
  if ($inputvalue.StartsWith("0X") -or $inputvalue.StartsWith("0x"))
  {
    $outputvalue = "16#" + ($inputvalue -Replace "0X" -Replace "0x") + "#"
  }
  else
  {
    $outputvalue = $inputvalue
  }
  return $outputvalue
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$package_name, $output_filename, $items = $args
if ([string]::IsNullOrEmpty($package_name))
{
  Write-Stderr "$($scriptname): *** Error: no package name specified."
  ExitWithCode 1
}
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Stderr "$($scriptname): *** Error: no output filename specified."
  ExitWithCode 1
}
if ($items.length -lt 1)
{
  Write-Stderr "$($scriptname): *** Error: no items specified."
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
    Write-Stderr "$($scriptname): *** Error: no item definition."
    ExitWithCode 1
  }
  switch ($spec)
  {
    { ($_ -eq "B") -or ($_ -eq "H") -or ($_ -eq "N") -or ($_ -eq "P") -or ($_ -eq "S") -or ($_ -eq "U") }
      { }
    default
      {
        Write-Stderr "$($scriptname): *** Error: no item specifier."
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
  $max_type_length++
}
$bseparator = " " * ($max_type_length - "Boolean".length)

$indent = "   "

$toolchain_cc = $(GetEnvVar "TOOLCHAIN_CC").Split(" ", 2)
$gcc = $toolchain_cc[0]
$gcc_args = $toolchain_cc[1]
$gcc_args = $gcc_args + " " + $(GetEnvVar "CC_SWITCHES_RTS")
$gcc_args = $gcc_args + " " + $(GetEnvVar "GCC_SWITCHES_PLATFORM")

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.CreateNoWindow = $true
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardInput = $true
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.FileName = $gcc
$pinfo.Arguments = $gcc_args + " -E -P -dM -c -"
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
    Write-Stderr "$($scriptname): *** Error: executing $($gcc)."
    ExitWithCode $p.ExitCode
  }
}
catch
{
  Write-Stderr "$($scriptname): *** Error: executing $($gcc)."
  ExitWithCode 1
}

$lines = $stdout.Split($nl, [StringSplitOptions]::RemoveEmptyEntries)

$gcc_defines = ""

$gcc_defines += $nl
$gcc_defines += "package $($package_name)" + $nl
$gcc_defines += "$($indent)with Pure       => True," + $nl
$gcc_defines += "$($indent)     SPARK_Mode => On" + $nl
$gcc_defines += "$($indent)is" + $nl
$gcc_defines += $nl

# special handling for ARM
if ($(GetEnvVar "CPU") -eq "ARM")
{
  $gcc_defines += "$($indent)ARM_ARCH_PROFILE_A : constant := 65;" + $nl
  $gcc_defines += "$($indent)ARM_ARCH_PROFILE_M : constant := 77;" + $nl
  $gcc_defines += "$($indent)ARM_ARCH_PROFILE_R : constant := 82;" + $nl
  $gcc_defines += $nl
}

foreach ($i in $items)
{
  $i_splitted = $i.Split(":")
  $i_macro  = $i_splitted[0]
  $i_tmacro = $i_splitted[1]
  $i_type   = $i_splitted[2]
  $i_spec   = $i_splitted[3]
  $mseparator = " " * ($max_tmacro_length - $i_tmacro.length)
  $tseparator = " " * ($max_type_length - $i_type.length)
  $found = ""
  foreach ($line in $lines)
  {
    $define = $line.Split(" ", 3)
    $macro = $define[1]
    $value = $define[2]
    if ($i_macro -eq $macro)
    {
      $found = "Y"
      switch ("$($i_spec)$($i_type)")
      {
        { $_ -eq "BBoolean" }
          { $value = "True" }
        { $_ -eq "HBoolean" }
          { if ($value -ne 0) { $value = "True" } else { $value = "False" } }
        { ($_ -eq "N") -or ($_ -eq "NInteger") }
          { if ([string]::IsNullOrEmpty($value)) { $value = "-1" } else { $value = $(ConvertHex $value) } }
        { ($_ -eq "P") -or ($_ -eq "PInteger") }
          { if ([int]$value -lt 1) { $value = "-1" } else { $value = $(ConvertHex $value) } }
        { $_ -eq "SString" }
          { if ([string]::IsNullOrEmpty($value)) { $value = "`"`"" } }
        { $_ -eq "UString" }
          { if ([string]::IsNullOrEmpty($value)) { $value = "`"`"" } else { $value = "`"$value`"" } }
        default
          {
            Write-Stderr "$($scriptname): *** Error: inconsistent item specification."
            ExitWithCode 1
          }
      }
      break
    }
  }
  if ([string]::IsNullOrEmpty($found))
  {
    switch ("$($i_spec)$($i_type)")
    {
      { ($_ -eq "BBoolean") -or ($_ -eq "HBoolean") }
        { $value = "False" }
      { ($_ -eq "N") -or ($_ -eq "NInteger") -or ($_ -eq "P") -or ($_ -eq "PInteger") }
        { $value = "-1" }
      { ($_ -eq "SString") -or ($_ -eq "UString") }
        { $value = "`"`"" }
      default
      {
        Write-Stderr "$($scriptname): *** Error: inconsistent item specification."
        ExitWithCode 1
      }
    }
  }
  $declstring = `
    "$($indent)$($i_tmacro)$($mseparator) : constant $($i_type)$($tseparator):= $($value);"
  $gcc_defines += "$($declstring)" + $nl
}

$gcc_defines += $nl
$gcc_defines += "end $($package_name);" + $nl

try
{
  Remove-Item -Path $output_filename -Force -ErrorAction Ignore
  New-Item -Name $output_filename -ItemType File | Out-Null
  Add-Content -Path $output_filename -Value $gcc_defines -NoNewLine
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($output_filename)."
  ExitWithCode 1
}

Write-Host "$($scriptname): $($output_filename): done."

ExitWithCode 0

