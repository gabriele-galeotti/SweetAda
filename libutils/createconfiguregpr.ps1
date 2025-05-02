
#
# Create "configure.gpr" GPRbuild project file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = configure project
# $2 = configure filename
#
# Environment variables:
# SWEETADA_PATH
# TOOLCHAIN_PREFIX
# GPRBUILD_PREFIX
# TOOLCHAIN_NAME
# GCC_WRAPPER
# GNATADC_FILENAME
# LIBRARY_DIRECTORY
# OBJECT_DIRECTORY
# PLATFORM
# CPU
# CPU_MODEL
# RTS_PATH
# RTS
# PROFILE
# ADA_MODE
# OPTIMIZATION_LEVEL
# STACK_LIMIT
# GNATBIND_SECSTACK
# USE_LIBGCC
# USE_LIBM
# USE_CLIBRARY
# ADAC_SWITCHES_RTS
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# GCC_SWITCHES_STARTUP
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
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
# print_V()                                                                    #
#                                                                              #
################################################################################
function print_V
{
  return ""
}

################################################################################
# print_I()                                                                    #
#                                                                              #
################################################################################
function print_I
{
  param([string]$t)
  $is = ""
  for ($i = 0 ; $i -lt $indentation_level ; $i++)
  {
    $is += $indentation_Ada
  }
  return "$is$t"
}

################################################################################
# print_list()                                                                 #
#                                                                              #
################################################################################
function print_list
{
  param([string]$list, [int]$il, [string]$is)
  $return_string = ""
  if ($list.Length -gt 0)
  {
    $list_array = $list -Split "\s+"
    $count = 0
    foreach ($s in $list_array)
    {
      $count++
      $s = "`"$s`""
      if ($count -ne $list_array.Length)
      {
        $s += ","
      }
      $return_string += $(print_I "$is$s") + $nl
    }
  }
  return $return_string
}

################################################################################
# LFPL_list()                                                                  #
#                                                                              #
# Build a list of the source languages detected in input arguments.            #
################################################################################
function LFPL_list
{
  param([string]$list)
  $LFP_S_files = $false
  $LFP_C_files = $false
  $LFP_AD_files = $false
  $LFPL = ""
  foreach ($f in $list.Split(" "))
  {
     if     ($f.Trim().EndsWith(".S") -and -not $LFP_S_files)
     {
       $LFP_S_files = $true
       if ($LFPL.Length -gt 0)
       {
         $LFPL = $LFPL + " "
       }
       $LFPL = $LFPL + "Asm_Cpp"
     }
     elseif ($f.Trim().EndsWith(".c") -and -not $LFP_C_files)
     {
       $LFP_C_files = $true
       if ($LFPL.Length -gt 0)
       {
         $LFPL = $LFPL + " "
       }
       $LFPL = $LFPL + "C"
     }
     elseif (($f.Trim().EndsWith(".adb") -or $f.Trim().EndsWith(".ads")) -and -not $LFP_AD_files)
     {
       $LFP_AD_files = $true
       if ($LFPL.Length -gt 0)
       {
         $LFPL = $LFPL + " "
       }
       $LFPL = $LFPL + "Ada"
     }
  }
  return $LFPL
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$configure_project = $args[0]
if ([string]::IsNullOrEmpty($configure_project))
{
  Write-Stderr "$($scriptname): *** Error: no project name specified."
  ExitWithCode 1
}
$configure_filename = $args[1]
if ([string]::IsNullOrEmpty($configure_filename))
{
  Write-Stderr "$($scriptname): *** Error: no project file specified."
  ExitWithCode 1
}

Remove-Item -Path $configure_filename -Force -ErrorAction Ignore
New-Item -Name $configure_filename -ItemType File | Out-Null

$indentation_Ada = "   " # Ada 3-space indentation style

$indentation_level = 0

$configuregpr = ""

#
# Initial empty line.
#
$configuregpr += $nl

#
# Declare project.
#
$configuregpr += $(print_I "abstract project $configure_project is") + $nl

$indentation_level++
$configuregpr += $(print_V $configure_filename) + $nl

#
# Configuration declarations.
#
$configuregpr += $(print_I "Platform                          := `"$(GetEnvVar PLATFORM)`";") + $nl
$configuregpr += $(print_I "Cpu                               := `"$(GetEnvVar CPU)`";") + $nl
$configuregpr += $(print_I "Cpu_Model                         := `"$(GetEnvVar CPU_MODEL)`";") + $nl
$configuregpr += $(print_I "SweetAda_Path                     := `"$(GetEnvVar SWEETADA_PATH)`";") + $nl
$configuregpr += $(print_I "Toolchain_Prefix                  := `"$(GetEnvVar TOOLCHAIN_PREFIX)`";") + $nl
$configuregpr += $(print_I "Toolchain_Name                    := `"$(GetEnvVar TOOLCHAIN_NAME)`";") + $nl
$configuregpr += $(print_I "Gprbuild_Prefix                   := `"$(GetEnvVar GPRBUILD_PREFIX)`";") + $nl
$configuregpr += $(print_I "GCC_Wrapper                       := `"$(GetEnvVar GCC_WRAPPER)`";") + $nl
$configuregpr += $(print_I "GnatAdc_Filename                  := `"$(GetEnvVar GNATADC_FILENAME)`";") + $nl
$configuregpr += $(print_I "Library_Directory                 := `"$(GetEnvVar LIBRARY_DIRECTORY)`";") + $nl
$configuregpr += $(print_I "Object_Directory                  := `"$(GetEnvVar OBJECT_DIRECTORY)`";") + $nl
$configuregpr += $(print_I "RTS                               := `"$(GetEnvVar RTS)`";") + $nl
$configuregpr += $(print_I "Profile                           := `"$(GetEnvVar PROFILE)`";") + $nl
$configuregpr += $(print_I "Ada_Mode                          := `"$(GetEnvVar ADA_MODE)`";") + $nl
$configuregpr += $(print_I "Stack_Limit                       := `"$(GetEnvVar STACK_LIMIT)`";") + $nl
$configuregpr += $(print_I "Gnatbind_SecStack                 := `"$(GetEnvVar GNATBIND_SECSTACK)`";") + $nl
$configuregpr += $(print_I "Use_LibGCC                        := `"$(GetEnvVar USE_LIBGCC)`";") + $nl
$configuregpr += $(print_I "Use_Libm                          := `"$(GetEnvVar USE_LIBM)`";") + $nl
$configuregpr += $(print_I "Use_CLibrary                      := `"$(GetEnvVar USE_CLIBRARY)`";") + $nl
$configuregpr += $(print_I "Optimization_Level                := `"$(GetEnvVar OPTIMIZATION_LEVEL)`";") + $nl
$indentl =                  "                                      "
$configuregpr += $(print_I "ADAC_Switches_RTS                 := (") + $nl
$configuregpr += $(print_list $(GetEnvVar ADAC_SWITCHES_RTS).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "CC_Switches_RTS                   := (") + $nl
$configuregpr += $(print_list $(GetEnvVar CC_SWITCHES_RTS).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "GCC_Switches_Platform             := (") + $nl
$configuregpr += $(print_list $(GetEnvVar GCC_SWITCHES_PLATFORM).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "RTS_Path                          := `"$(GetEnvVar RTS_PATH)`";") + $nl
$configuregpr += $(print_I "Lowlevel_Files_Platform           := (") + $nl
$configuregpr += $(print_list $(GetEnvVar LOWLEVEL_FILES_PLATFORM).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "Lowlevel_Files_Platform_Languages := (") + $nl
$configuregpr += $(print_list $(LFPL_list $(GetEnvVar LOWLEVEL_FILES_PLATFORM)) $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "GCC_Switches_Lowlevel_Platform    := (") + $nl
$configuregpr += $(print_list $(GetEnvVar GCC_SWITCHES_LOWLEVEL_PLATFORM).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "Include_Directories               := (") + $nl
$configuregpr += $(print_list $(GetEnvVar INCLUDE_DIRECTORIES).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_I "Implicit_ALI_Units                := (") + $nl
$configuregpr += $(print_list $(GetEnvVar IMPLICIT_ALI_UNITS).Trim(" ") $indentation_level $indentl)
$configuregpr += $(print_I "                                     );") + $nl
$configuregpr += $(print_V) + $nl

#
# Close the project.
#
$indentation_level--
$configuregpr += $(print_I "end $configure_project;") + $nl

try
{
  Add-Content -Path $configure_filename -Value "$configuregpr" -NoNewline
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($configure_filename)."
  ExitWithCode 1
}

Write-Host "$($scriptname): $($configure_filename): done."

ExitWithCode 0

