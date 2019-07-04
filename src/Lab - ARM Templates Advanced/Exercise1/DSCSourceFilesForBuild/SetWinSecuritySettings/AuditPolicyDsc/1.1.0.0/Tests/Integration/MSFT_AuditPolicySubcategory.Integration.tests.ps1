
$script:DSCModuleName      = 'AuditPolicyDsc'
$script:DSCResourceName    = 'MSFT_AuditPolicySubcategory'

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

# set the subcategory details being tested
$script:subCategory = 'Credential Validation'

# Using try/finally to always cleanup even if something awful happens.
try
{
    #region Integration Tests
    $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCResourceName).config.ps1"
    . $ConfigFile

    Describe "$($script:DSCResourceName)_Integration" {

        Context 'Should enable failure audit flag' {
            #region DEFAULT TESTS
            
            $auditFlag       = 'Failure'
            $auditFlagEnsure = 'Present'

            # set the system Subcategory to the incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/subcategory:$subCategory" '/failure:disable'
            
            It 'Should compile without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -Name $subCategory `
                                                          -AuditFlag $auditFlag `
                                                          -AuditFlagEnsure $auditFlagEnsure `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should Not Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -Verbose -ErrorAction Stop } | Should Not Throw
            }
            #endregion
            
            $currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop

            It 'Should return the correct configuration' {
            
                $currentConfig.Name      | Should Be $subCategory
                $currentConfig.AuditFlag | Should Match $auditFlag
                $currentConfig.Ensure    | Should Be $auditFlagEnsure
            }
        }

        Context 'Should disable failure audit flag' {
            #region DEFAULT TESTS
            
            $auditFlag       = 'Failure'
            $auditFlagEnsure = 'Absent'

            # set the system Subcategory to the incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/subcategory:$subCategory" '/failure:enable'
            
            It 'Should compile without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -Name $subCategory `
                                                          -AuditFlag $auditFlag `
                                                          -AuditFlagEnsure $auditFlagEnsure `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -Verbose -ErrorAction Stop } | Should Not throw
            }
            #endregion
            
            $currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop

            It 'Should return the correct configuration' {
            
                $currentConfig.Name      | Should Be $subCategory
                $currentConfig.AuditFlag | Should Not Match $auditFlag
                $currentConfig.Ensure    | Should Be $auditFlagEnsure
            }
        }

        Context 'Should enable success audit flag' {
            #region DEFAULT TESTS
            
            $auditFlag       = 'Success'
            $auditFlagEnsure = 'Present'

            # set the system Subcategory to the incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/subcategory:$subCategory" '/success:disable'
            
            It 'Should compile without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -Name $subCategory `
                                                          -AuditFlag $auditFlag `
                                                          -AuditFlagEnsure $auditFlagEnsure `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -Verbose -ErrorAction Stop } | Should Not throw
            }
            #endregion
            
            $currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop

            It 'Should return the correct configuration' {
            
                $currentConfig.Name      | Should Be $subCategory
                $currentConfig.AuditFlag | Should Match $auditFlag
                $currentConfig.Ensure    | Should Be $auditFlagEnsure
            }
        }

        Context 'Should disable success audit flag' {
            #region DEFAULT TESTS
            
            $auditFlag       = 'Success'
            $auditFlagEnsure = 'Absent'

            # set the system Subcategory to the incorrect state to ensure a valid test.
            & 'auditpol' '/set' "/subcategory:$subCategory" '/success:enable'
            
            It 'Should compile without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -Name $subCategory `
                                                          -AuditFlag $auditFlag `
                                                          -AuditFlagEnsure $auditFlagEnsure `
                                                          -OutputPath $TestDrive
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -Verbose -ErrorAction Stop } | Should Not throw
            }
            #endregion
            
            $currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop

            It 'Should return the correct configuration' {
            
                $currentConfig.Name      | Should Be $subCategory
                $currentConfig.AuditFlag | Should Not Match $auditFlag
                $currentConfig.Ensure    | Should Be $auditFlagEnsure
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
