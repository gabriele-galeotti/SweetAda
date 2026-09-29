
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
# $1 .. 2 = -s <symlink_mode>
# $3 .. n = destination filename list
# $n+1    = mandatory "-o" switch to separate destinations and targets
# $n+2 .. = target filename list
# The two lists must have the same length.
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

$ndestination = 0
$ntarget = 0

#
# Parse command line arguments.
#
$argsindex = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $optionchar = $args[$argsindex].Substring(1)
    if ($optionchar -eq "s")
    {
      if ($argsindex -ne 0)
      {
        Write-Stderr "$($scriptname): *** Error: misplaced -s option."
        ExitWithCode 1
      }
      $argsindex++
      $symlink_mode = $args[$argsindex]
      $destinationindex = $argsindex + 1
    }
    elseif ($optionchar -eq "o")
    {
      $targetindex = $argsindex + 1
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
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

if ($symlink_mode -eq "HARD")
{
  while ($ndestination -gt 0)
  {
    $destination = $args[$destinationindex]
    try
    {
      Remove-Item -Path $destination -Force -ErrorAction Ignore
    }
    catch
    {
      Write-Stderr "$($scriptname): *** Error: Remove-Item (HardLink)."
      ExitWithCode 1
    }
    if ($verbose -eq "Y")
    {
      Write-Host "$($scriptname): removed '$($destination)'"
    }
    $destinationindex++
    $ndestination--
  }
}
elseif ($symlink_mode -eq "COPY")
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
      if ($destination_mtime -ne $target_mtime)
      {
        Write-Host "file [installed/symlinked]: `"$($destination)`""
        Write-Host "  -> will be deleted, but timestamp is different from that of"
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
        try
        {
          Remove-Item -Path $destination -Force -ErrorAction Ignore
        }
        catch
        {
          Write-Stderr "$($scriptname): *** Error: Remove-Item."
          ExitWithCode 1
        }
        if ($verbose -eq "Y")
        {
          Write-Host "$($scriptname): removed '$($destination)'"
        }
      }
    }
    $destinationindex++
    $targetindex++
    $ntarget--
  }
}
else
{
  # do not flag an error since some files could have been deleted, and this
  # should not preempt the cleanup phase; in any case a new re-initialization
  # will delete dangling files
  #Write-Stderr "$($scriptname): *** Error: wrong mode."
  #ExitWithCode 1
}

ExitWithCode 0

