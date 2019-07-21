
$script:DSCModuleName      = 'AuditPolicyDsc'
$script:DSCResourceName    = 'MSFT_AuditPolicyOption'

#region HEADER
# Integration Test Template Version: 1.1.1
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Integration
#endregion

# Set the option details being tested
$optionName  = 'AuditBaseDirectories'

# Using try/finally to always cleanup even if something awful happens.
try
{
    #region Integration Tests
    $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCResourceName).config.ps1"
    . $ConfigFile 

    Describe "$($script:DSCResourceName)_Integration" {
        
        Context 'Should set option to Enabled' {
            
            #region DEFAULT TESTS

            # Set the option value to test
            $optionValue = 'Enabled'
            # Set the test system value to an incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/option:$optionName" '/value:disable'  

            It 'Should compile and apply the MOF without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -OptionName $optionName `
                                                          -OptionValue $optionValue `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { $script:currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop } | 
                    Should Not throw
            }

            #endregion

            It 'Should return the correct option name' {
                $script:currentConfig.Name | Should Be $optionName
            }

            It 'Should return the correct option value' {
                $script:currentConfig.Value | Should Be $optionValue
            }
            
            It 'Should return $true' {
                (Test-DscConfiguration -Path $TestDrive).InDesiredState | Should Be $true
            }
        }

        Context 'Should set option to Disabled' {

            #region DEFAULT TESTS

            # Set the option value to test
            $optionValue = 'Disabled'
            # Set the system value to an incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/option:$optionName" '/value:enable'  

            It 'Should compile and apply the MOF without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -OptionName $optionName `
                                                          -OptionValue $optionValue `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { $script:currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop } | 
                    Should Not throw
            }

            #endregion

            It 'Should return the correct option name' {
                $script:currentConfig.Name | Should Be $optionName
            }

            It 'Should return the correct option value' {
                $script:currentConfig.Value | Should Be $optionValue
            }
            
            It 'Should return $true' {
                (Test-DscConfiguration -Path $TestDrive).InDesiredState | Should Be $true
            }
        }
    }
    #endregion
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
