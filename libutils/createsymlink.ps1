
#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional initial -c physical copy instead of symlink
# optional initial -m <filelist> to record symlinks
# optional initial -v for verbosity
# $1 = target filename or directory
# $2 = link name filename or directory
# every following pair is another symlink
#
# Environment variables:
# VERBOSE
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

$GetEnvironmentVariable_signature = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern uint
GetEnvironmentVariable(
  string                          lpName,
  [Out] System.Text.StringBuilder lpBuffer,
  uint                            nSize
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
      Write-Host "$($scriptname): *** Error: GetEnvVar: buffer size < $($nchars)."
      ExitWithCode 1
    }
    return [string]$gev_buffer
  }
}

################################################################################
# SetTimeOfSymlink()                                                           #
#                                                                              #
################################################################################

$CreateFile_signature = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern IntPtr
CreateFile(
  string filename,
  uint   access,
  uint   share,
  IntPtr securityAttributes,
  uint   creationDisposition,
  uint   flagsAndAttributes,
  IntPtr templateFile
  );
'@
Add-Type -MemberDefinition $CreateFile_signature -Name "Win32CreateFile" -Namespace Win32

$CloseHandle_signature = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool
CloseHandle(IntPtr hHandle);
'@
Add-Type -MemberDefinition $CloseHandle_signature -Name "Win32CloseHandle" -Namespace Win32

$GetFileTime_signature = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool
GetFileTime(
  IntPtr   hFile,
  ref long lpCreationTime,
  ref long lpLastAccessTime,
  ref long lpLastWriteTime
  );
'@
Add-Type -MemberDefinition $GetFileTime_signature -Name "Win32GetFileTime" -Namespace Win32

$SetFileTime_signature = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool
SetFileTime(
  IntPtr   hFile,
  ref long lpCreationTime,
  ref long lpLastAccessTime,
  ref long lpLastWriteTime
  );
'@
Add-Type -MemberDefinition $SetFileTime_signature -Name "Win32SetFileTime" -Namespace Win32

function SetTimeOfSymlink
{
  param([string]$symlink, [string]$source)
  [Long]$CreationTime   = 0
  [Long]$LastAccessTime = 0
  [Long]$LastWriteTime  = 0
  $handle = [Win32.Win32CreateFile]::CreateFile(
              $source,
              0x80,
              0,
              [System.IntPtr]::Zero,
              3,
              0x80,
              [System.IntPtr]::Zero
              )
  [Win32.Win32GetFileTime]::GetFileTime(
    $handle,
    [ref]$CreationTime,
    [ref]$LastAccessTime,
    [ref]$LastWriteTime) | Out-Null
  [Win32.Win32CloseHandle]::CloseHandle($handle) | Out-Null
  $handle = [Win32.Win32CreateFile]::CreateFile(
              $symlink,
              0x100,
              0,
              [System.IntPtr]::Zero,
              3,
              0x200000,
              [System.IntPtr]::Zero
              )
  [Win32.Win32SetFileTime]::SetFileTime(
    $handle,
    [ref]$CreationTime,
    [ref]$LastAccessTime,
    [ref]$LastWriteTime) | Out-Null
  [Win32.Win32CloseHandle]::CloseHandle($handle) | Out-Null
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# check if we can use $IsWindows
if ($PSVersionTable.PSVersion.Major -eq "5")
{
  if ([System.Environment]::OSVersion.Platform -eq "Win32NT")
  {
    $IsWindows = $true
  }
  else
  {
    $IsWindows = $false
  }
}

# check environment variable for verbosity
$verbose = $(GetEnvVar VERBOSE)

# parse command line arguments
$fileindex = 0
while ($fileindex -lt $args.length)
{
  if ($args[$fileindex][0] -eq "-")
  {
    $optionchar = $args[$fileindex].Substring(1)
    if ($optionchar -eq "c")
    {
      if ($IsWindows)
      {
        $symlinkcopy = "Y"
      }
    }
    elseif ($optionchar -eq "m")
    {
      $fileindex++
      $filelist_filename = $args[$fileindex]
    }
    elseif ($optionchar -eq "v")
    {
      $verbose = "Y"
    }
    else
    {
      Write-Host "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
  }
  else
  {
    break
  }
  $fileindex++
}

# check for at least one symlink target
if ($fileindex -ge $args.length)
{
  Write-Host "$($scriptname): *** Error: no symlink target specified."
  ExitWithCode 1
}

# create filelist if specified
if (![string]::IsNullOrEmpty($filelist_filename))
{
  if (-not (Test-Path $filelist_filename))
  {
    "INSTALLED_FILENAMES :=" | Set-Content $filelist_filename
    if ($symlinkcopy -eq "Y")
    {
      "ORIGIN_FILENAMES :=" | Add-Content $filelist_filename
    }
  }
}

# loop as long as an argument exists
# when arguments are exhausted, exit
while ($fileindex -lt $args.length)
{
  $target = $args[$fileindex]
  # then, the 2nd argument of the pair should exist
  if (($fileindex + 1) -ge $args.length)
  {
    Write-Host "$($scriptname): *** Error: no symlink link name specified."
    ExitWithCode 1
  }
  if (Test-Path -Path $target -PathType Leaf)
  {
    $link_name = $args[$fileindex + 1]
    Remove-Item -Path $link_name -Force -ErrorAction Ignore
    if ($symlinkcopy -eq "Y")
    {
      Copy-Item $target -Destination $link_name | Out-Null
    }
    else
    {
      New-Item -ItemType SymbolicLink -Path $link_name -Target $target | Out-Null
      if ($IsWindows)
      {
        SetTimeOfSymlink $link_name $target
      }
    }
    if ($verbose -eq "Y")
    {
      Write-Host "$($link_name) -> $($target)"
    }
    if (![string]::IsNullOrEmpty($filelist_filename))
    {
      "INSTALLED_FILENAMES += $($link_name)" | Add-Content $filelist_filename
      if ($symlinkcopy -eq "Y")
      {
        "ORIGIN_FILENAMES += $($target)" | Add-Content $filelist_filename
      }
    }
  }
  elseif (Test-Path -Path $target -PathType Container)
  {
    $link_directory = $args[$fileindex + 1]
    $files = (Get-ChildItem -Force -File $target).Name
    foreach ($f in $files)
    {
      Remove-Item                                             `
        -Path (Join-Path -Path $link_directory -ChildPath $f) `
        -Force -ErrorAction Ignore
      if ($symlinkcopy -eq "Y")
      {
        Copy-Item                                                      `
          (Join-Path -Path $target -ChildPath $f)                      `
          -Destination (Join-Path -Path $link_directory -ChildPath $f) `
          | Out-Null
      }
      else
      {
        New-Item                                                                       `
          -ItemType SymbolicLink -Path (Join-Path -Path $link_directory -ChildPath $f) `
          -Target (Join-Path -Path $target -ChildPath $f)                              `
          | Out-Null
        if ($IsWindows)
        {
          SetTimeOfSymlink $link_name $target
        }
      }
      if ($verbose -eq "Y")
      {
        Write-Host "$($link_directory)/$($f) -> $($target)/$($f)"
      }
      if (![string]::IsNullOrEmpty($filelist_filename))
      {
        "INSTALLED_FILENAMES += $(Join-Path -Path $link_directory -ChildPath $f)" `
        | Add-Content $filelist_filename
        if ($symlinkcopy -eq "Y")
        {
          "ORIGIN_FILENAMES += $(Join-Path -Path $target -ChildPath $f)" `
          | Add-Content $filelist_filename
        }
      }
    }
  }
  else
  {
    Write-Host "$($scriptname): *** Error: no file or directory `"$($target)`"."
    ExitWithCode 1
  }
  # shift to the next argument pair
  $fileindex += 2
}

ExitWithCode 0

