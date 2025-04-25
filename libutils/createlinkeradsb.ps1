
#
# SweetAda linker.ad[s|b] generator.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = linker script filename
#
# Environment variables:
# CORE_DIRECTORY
# KERNEL_PARENT_PATH
#

#
# LINKERADSB:<symbol_name>:<Ada_identifier>
#
# symbol_name: linker symbol name
# Ada_identifier: Ada identifier name
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$ldscript_filename = $args[0]
if ([string]::IsNullOrEmpty($ldscript_filename))
{
  Write-Stderr "$($scriptname): *** Error: no linker script specified."
  ExitWithCode 1
}

$linker_symbols = @()
foreach ($textline in Get-Content $ldscript_filename)
{
  if ($textline.Contains("LINKERADSB:"))
  {
    $textlinearray = $textline.Split(" ")
    foreach ($word in $textlinearray)
    {
      if ($word.StartsWith("LINKERADSB:"))
      {
        $linker_symbols += $word
        break
      }
    }
  }
}

if ($linker_symbols.Count -eq 0)
{
  ExitWithCode 0
}

$PACKAGE = "Linker"
$output_directory = Join-Path                                  `
                      -Path $(GetEnvVar "KERNEL_PARENT_PATH")  `
                      -ChildPath $(GetEnvVar "CORE_DIRECTORY")
$OUTPUT_FILENAME_ADS = Join-Path -Path $output_directory -ChildPath "linker.ads"
$OUTPUT_FILENAME_ADB = Join-Path -Path $output_directory -ChildPath "linker.adb"

$linkerads = ""
$linkeradb = ""
$indent = "   "

$linkerads += $nl
$linkerads += "with System.Storage_Elements;" + $nl
$linkerads += $nl
$linkerads += "package $PACKAGE" + $nl
$linkerads += $indent + "with Pure       => True," + $nl
$linkerads += $indent + "     SPARK_Mode => On" + $nl
$linkerads += $indent + "is" + $nl
$linkerads += $nl

$linkeradb += $nl
$linkeradb += "with Bits;" + $nl
$linkeradb += $nl
$linkeradb += "package body $PACKAGE" + $nl
$linkeradb += $indent + "is" + $nl
$linkeradb += $nl
$linkeradb += $indent + "type Symbol_Type is new Bits.Null_Object" + $nl
$linkeradb += $indent + "   with Convention => Asm;" + $nl
$linkeradb += $nl
foreach ($symbol in $linker_symbols)
{
  $symbol_array = $symbol.Split(":")
  $symbol_name = $symbol_array[1]
  $Ada_Identifier = $symbol_array[2]
  $linkerads += $indent + "function $Ada_identifier" + $nl
  $linkerads += $indent + "   return System.Storage_Elements.Integer_Address" + $nl
  $linkerads += $indent + "   with Inline => True;" + $nl
  $linkerads += $nl
  $linkeradb += $indent + "function $Ada_identifier" + $nl
  $linkeradb += $indent + "   return System.Storage_Elements.Integer_Address" + $nl
  $linkeradb += $indent + "   is" + $nl
  $linkeradb += $indent + "   Symbol : aliased constant Symbol_Type" + $nl
  $linkeradb += $indent + "      with Import    => True," + $nl
  $linkeradb += $indent + "           Link_Name => `"$symbol_name`";" + $nl
  $linkeradb += $indent + "begin" + $nl
  $linkeradb += $indent + "   return System.Storage_Elements.To_Integer (Symbol'Address);" + $nl
  $linkeradb += $indent + "end $Ada_identifier;" + $nl
  $linkeradb += $nl
}
$linkerads += "end $PACKAGE;" + $nl
$linkeradb += "end $PACKAGE;" + $nl

try
{
  Remove-Item -Path $OUTPUT_FILENAME_ADS -Force -ErrorAction Ignore
  New-Item -Name $OUTPUT_FILENAME_ADS -ItemType File | Out-Null
  Add-Content -Path $OUTPUT_FILENAME_ADS -Value $linkerads -NoNewLine
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($OUTPUT_FILENAME_ADS)."
  ExitWithCode 1
}

Write-Host "$($scriptname): linker.ads: done."

try
{
  Remove-Item -Path $OUTPUT_FILENAME_ADB -Force -ErrorAction Ignore
  New-Item -Name $OUTPUT_FILENAME_ADB -ItemType File | Out-Null
  Add-Content -Path $OUTPUT_FILENAME_ADB -Value $linkeradb -NoNewLine
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($OUTPUT_FILENAME_ADB)."
  ExitWithCode 1
}

Write-Host "$($scriptname): linker.adb: done."

ExitWithCode 0

