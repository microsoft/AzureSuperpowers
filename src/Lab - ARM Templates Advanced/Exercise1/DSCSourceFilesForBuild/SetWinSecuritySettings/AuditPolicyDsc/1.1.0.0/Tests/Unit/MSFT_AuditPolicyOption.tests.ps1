
$script:DSCModuleName   = 'AuditPolicyDsc'
$script:DSCResourceName = 'MSFT_AuditPolicyOption'

#region HEADER
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}
else
{
    & git @('-C',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'),'pull')
}
Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Unit 
#endregion

# Begin Testing
try
{
    #region Pester Tests

    InModuleScope $script:DSCResourceName {

        #region Pester Test Initialization

        # set the audit option test strings to Mock
        $testParameters = @{
            Name  = 'CrashOnAuditFail'
            Value = 'Enabled'
        }

        #endregion

        #region Function Get-TargetResource
        Describe "$($script:DSCResourceName)\Get-TargetResource" {

            Context 'Option Enabled' {
                
                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Enabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable
                
                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | 
                        Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name  | Should Be $testParameters.Name
                    $script:getTargetResourceResult.Value | Should Be $testParameters.Value
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }

            Context 'Option Disabled' {

                $testParameters.Value = 'Disabled'
                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Disabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | 
                        Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name  | Should Be $testParameters.Name
                    $script:getTargetResourceResult.Value | Should Be $testParameters.Value
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe "$($script:DSCResourceName)\Test-TargetResource" {
            
            $testParameters.Value = 'Enabled'

            Context 'Option set to enabled and should be' {

                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Enabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | 
                        Should Not Throw
                }

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }

            Context 'Option set to enabled and should not be' {

                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Disabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | 
                        Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }

            $testParameters.Value = 'Disabled'

            Context 'Option set to disabled and should be' {

                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Disabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | 
                        Should Not Throw
                }
                
                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }

            Context 'Option set to disabled and should not be' {

                Mock -CommandName Get-AuditOption -MockWith { 
                    return 'Enabled' } -ModuleName MSFT_AuditPolicyOption -Verifiable
                
                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | 
                        Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-AuditOption -Exactly 1
                } 
            }
        }
        #endregion

        #region Function Set-TargetResource
        Describe "$($script:DSCResourceName)\Set-TargetResource" {
            
            $testParameters.Value = 'Enabled'

            Context 'Option to Enabled' {

                Mock -CommandName Set-AuditOption -MockWith { } `
                     -ModuleName MSFT_AuditPolicyOption -Verifiable
                    
                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Set-AuditOption -Exactly 1
                } 
            }

            $testParameters.Value = 'Disabled'

            Context 'Option to Disabled' {

                Mock -CommandName Set-AuditOption -MockWith { } `
                     -ModuleName MSFT_AuditPolicyOption -Verifiable
                    
                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Set-AuditOption -Exactly 1
                } 
            }
        }
        #endregion

        #region Helper Cmdlets
        Describe 'Private function Get-AuditOption' { 
            
            [String] $name = 'CrashOnAuditFail'
            
            Context 'Get audit policy option enabled' {
                
                [String] $value = 'Enabled'
                <# 
                    the return is 3 lines Header, blank line, data
                    ComputerName,System,Subcategory,GUID,AuditFlags
                #>
                Mock -CommandName Invoke-Auditpol -MockWith { 
                    @("","","$env:COMPUTERNAME,,Option:$name,,$value,,") 
                } -ParameterFilter { $Command -eq 'Get' } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditOptionResult = Get-AuditOption -Name $name } | 
                        Should Not Throw
                } 

                It 'Should return the correct value' {
                    $script:getAuditOptionResult | Should Be $value
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1
                } 
            }

            Context 'Get audit policy option disabled' {
                
                [String] $value = 'Disabled'
                <# 
                    the return is 3 lines Header, blank line, data
                    ComputerName,System,Subcategory,GUID,AuditFlags
                #>
                Mock -CommandName Invoke-Auditpol -MockWith { 
                    @("","","$env:COMPUTERNAME,,Option:$name,,$value,,") 
                } -ParameterFilter { $Command -eq 'Get' } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditOptionResult = Get-AuditOption -Name $name } | 
                        Should Not Throw
                } 

                It 'Should return the correct value' {
                    $script:getAuditOptionResult | Should Be $value
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1
                } 
            }
        }

        Describe 'Private function Set-AuditOption' { 

            [String] $name  = "CrashOnAuditFail"

            Context "Set audit poliy option to enabled" {

                [String] $value = "Enabled"

                Mock -CommandName Invoke-Auditpol -MockWith { } -ParameterFilter {
                    $Command -eq 'Set' } -Verifiable

                It 'Should not throw an exception' {
                    { Set-AuditOption -Name $name -Value $value } | Should Not Throw
                }   

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1
                } 
            }

            Context "Set audit policy option to disabled" {

                [String] $value = "Disabled"

                Mock -CommandName Invoke-Auditpol -MockWith { } -ParameterFilter {
                    $Command -eq 'Set' } -Verifiable

                It 'Should not throw an exception' {
                    { Set-AuditOption -Name $name -Value $value } | Should Not Throw
                }   

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1
                } 
            }
        }
        #endregion
    }
    #endregion
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
