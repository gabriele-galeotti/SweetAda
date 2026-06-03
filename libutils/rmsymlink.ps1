
#
# Remove a set of (virtual) symbolic/soft links.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 .. n = destination filename list
# $n+1    = mandatory "-o" switch to separate destinations and targets
# $n+2 .. = target filename list
# The two lists must have the same length.
#
# Environment variables:
# USE_HARDLINK
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

# use hard links
$use_hardlink = $(GetEnvVar USE_HARDLINK)

# parse command line arguments
$argsindex = 0
$destinationindex = 0
$targetindex = 0
$ndestination = 0
$ntarget = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex] -eq "-o")
  {
    $targetindex = $argsindex + 1
  }
  else
  {
    if ($targetindex -gt 0)
    {
      $ntarget++
    }
    else
    {
      $ndestination++
    }
  }
  $argsindex++
}

if ($use_hardlink -eq "Y")
{
  while ($destination -gt 0)
  {
    $destination = $args[$destinationindex]
    Remove-Item -Path $destination -Force -ErrorAction Ignore
    $destinationindex++
    $destination--
  }
}
else
{
if ($ndestination -ne $ntarget)
{
  Write-Stderr "$($scriptname): *** Error: wrong filelist specification."
  ExitWithCode 1
}
  while ($ntarget -gt 0)
  {
    $remove = $false
    $destination = $args[$destinationindex]
    $target = $args[$targetindex]
    if (Test-Path $destination)
    {
      $destination_mtime = (Get-Item $destination).LastWriteTime
      $target_mtime = (Get-Item $target).LastWriteTime
      if ($destination_mtime -gt $target_mtime)
      {
        Write-Host "file [installed/symlinked]: `"$($destination)`""
        Write-Host "  -> will be deleted, but timestamp is more recent than"
        Write-Host "file [origin]:              `"$($target)`""
        Write-Host "*** Warning: changes could be lost."
        while ($true)
        {
          $answer = (Read-Host "[U]pdate origin or [I]gnore changes").ToUpper()
          if ($answer -eq "U")
          {
            Move-Item -Path $destination -Destination $target -Force
            break
          }
          elseif ($answer -eq "I")
          {
            $remove = $true
            break
          }
        }
      }
      else
      {
        $remove = $true
      }
      if ($remove)
      {
        Remove-Item -Path $destination -Force -ErrorAction Ignore
      }
    }
    $destinationindex++
    $targetindex++
    $ntarget--
  }
}

ExitWithCode 0

