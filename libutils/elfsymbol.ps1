
#
# Extract a symbol value from an ELF file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = symbol name
# $2 = input filename
#
# Environment variables:
# TOOLCHAIN_NM
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

$prefix_string = ""

# parse command line arguments
$argsindex = 0
if ($args[$argsindex] -eq "-p")
{
  $argsindex++
  $prefix_string = $args[$argsindex]
  $argsindex++
}
$symbol = [string]$args[$argsindex]
if ([string]::IsNullOrEmpty($symbol))
{
  Write-Stderr "$($scriptname): *** Error: no symbol name specified."
  ExitWithCode 1
}
$argsindex++
$filename = $args[$argsindex]
if ([string]::IsNullOrEmpty($filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}

$toolchain_nm = $(GetEnvVar "TOOLCHAIN_NM").Split(" ", 2)
$nm = $toolchain_nm[0]
$nm_args = $toolchain_nm[1]

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.CreateNoWindow = $true
$pinfo.UseShellExecute = $false
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.FileName = $nm
$pinfo.Arguments = $nm_args + " --format=posix $filename"
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
    Write-Host "${scriptname}: *** Error: executing ${nm}."
    ExitWithCode $p.ExitCode
  }
}
catch
{
  Write-Host "${scriptname}: *** Error: executing ${nm}."
  ExitWithCode 1
}

$lines = $stdout.Split($nl, [StringSplitOptions]::RemoveEmptyEntries)
foreach ($line in $lines)
{
  $symbolspec = $line.Split(" ", 4)
  if ($symbolspec[0] -eq $symbol)
  {
    Write-Host "$(${prefix_string})0x$($symbolspec[2])"
    break
  }
}

ExitWithCode 0

