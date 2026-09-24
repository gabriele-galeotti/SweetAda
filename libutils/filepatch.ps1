
#
# Patch a file.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = filename
# $2 = offset in hexadecimal format
# $3 = string containing the hexadecimal representation of a byte to patch in
#
# Environment variables:
# VERBOSE
# BRIEFTEXT_WIDTH
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
      return [string][Environment]::GetEnvironmentVariable($varname)
    }
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# check environment variable for verbosity
$verbose = $(GetEnvVar VERBOSE)

#
# Basic input parameters check.
#
$filename = $args[0]
if ([string]::IsNullOrEmpty($filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$offset = [Convert]::ToInt32($args[1], 16)
if ([string]::IsNullOrEmpty($offset))
{
  Write-Stderr "$($scriptname): *** Error: no offset specified."
  ExitWithCode 1
}
$patchstring = $args[2]
if ([string]::IsNullOrEmpty($patchstring))
{
  Write-Stderr "$($scriptname): *** Error: no patchstring specified."
  ExitWithCode 1
}

try
{
  $filebytes = [System.IO.File]::ReadAllBytes($filename)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: reading $($filename)."
  ExitWithCode 1
}

$patchstring.Split(" ") | foreach {
  $filebytes[$offset] = [Convert]::ToInt32($_, 16)
  $offset++
}

if ($verbose -eq "Y")
{
  Write-Host "$($scriptname): patching file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."
}
else
{
  $briefcommand = "[FILEPATCH]".PadRight($(GetEnvVar "BRIEFTEXT_WIDTH"), " ")
  Write-Host "$($briefcommand) $(Split-Path -Path $filename -Leaf -Resolve)"
}

try
{
  [System.IO.File]::WriteAllBytes($filename, $filebytes)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($filename)."
  ExitWithCode 1
}

ExitWithCode 0

