
#
# Create "gnat.adc" file.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = PROFILE
# $2 = input GNATADC_FILENAME template
# $3 = output GNATADC_FILENAME
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
if ($args.length -lt 3)
{
  Write-Stderr "$($scriptname): *** Error: insufficient number of arguments specified."
  ExitWithCode 1
}
$profile = $args[0]
$gnatadc_filename_template = $args[1]
$gnatadc_filename = $args[2]
if (-not (Test-Path -Path "$($gnatadc_filename_template)"))
{
  Write-Stderr "$($scriptname): *** Error: $($gnatadc_filename_template) not found."
  ExitWithCode 1
}

$gnatadc = ""

$pragma_seen = $false
foreach ($textline in Get-Content "$($gnatadc_filename_template)")
{
  $textlinearray = $textline -Split "--"
  $pragma = $textlinearray[0].Trim(" ")
  $profiles = $textlinearray[1]
  if (($pragma -eq "") -or ($profiles -eq ""))
  {
    continue
  }
  $profilesarray = ($profiles.Trim(" ") -Replace "\s+"," ").Split(" ")
  foreach ($p in $profilesarray)
  {
    if ($p -eq $profile)
    {
      $gnatadc += "$($pragma)" + $nl
      $pragma_seen = $true
      break
    }
  }
}
if (-not $pragma_seen)
{
  Write-Stderr "$($scriptname): *** Warning: no pragma processed."
}

try
{
  Remove-Item -Path $gnatadc_filename -Force -ErrorAction Ignore
  New-Item -Name $gnatadc_filename -ItemType File | Out-Null
  Add-Content -Path $gnatadc_filename -Value $gnatadc -NoNewLine
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($gnatadc_filename)."
  ExitWithCode 1
}

if ($verbose -eq "Y")
{
  Write-Host "$($scriptname): $($gnatadc_filename): done."
}
else
{
  $briefcommand = "[GNATADC]".PadRight($(GetEnvVar "BRIEFTEXT_WIDTH"), " ")
  Write-Host "$($briefcommand) $($gnatadc_filename)"
}

ExitWithCode 0

