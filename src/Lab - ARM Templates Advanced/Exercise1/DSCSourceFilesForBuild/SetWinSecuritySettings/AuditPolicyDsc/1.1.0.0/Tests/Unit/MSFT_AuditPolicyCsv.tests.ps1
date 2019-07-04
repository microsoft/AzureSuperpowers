
$script:DSCModuleName   = 'AuditPolicyDsc'
$script:DSCResourceName = 'MSFT_AuditPolicyCsv'

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

        # The script scope does not pierce the InModuleScope  
        $script:DSCResourceName = 'MSFT_AuditPolicyCsv'

        # Create temporary files to hold the test data. 
        $script:currentAuditpolicyCsv = ([system.IO.Path]::GetTempFileName()).Replace('.tmp','.csv')
        $script:desiredAuditpolicyCsv = ([system.IO.Path]::GetTempFileName()).Replace('.tmp','.csv')

        $script:csvPath = $script:desiredAuditpolicyCsv

        # Create the current auditpol backup file to test against. 
        @(@("Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value")
        @(",System,IPsec Driver,{0CCE9213-69AE-11D9-BED3-505054503030},Failure,,2")
        @(",System,System Integrity,{0CCE9212-69AE-11D9-BED3-505054503030},Success,,1")
        @(",System,Security System Extension,{0CCE9211-69AE-11D9-BED3-505054503030},No Auditing,,0")
        @(",,Option:CrashOnAuditFail,,Disabled,,0")
        @(",,RegistryGlobalSacl,,,,")) | Out-File $script:currentAuditpolicyCsv -Encoding utf8 -Force

        Describe "$($script:DSCResourceName)\Get-TargetResource" {

            Mock -CommandName Invoke-SecurityCmdlet -ParameterFilter { $Action -eq 'Export' } `
                 -MockWith { } -Verifiable            
            
            It 'Should not throw an exception' {
                { 
                    $script:getTargetResourceResult = Get-TargetResource -CsvPath $script:csvPath `
                                                                         -IsSingleInstance 'Yes'
                } | Should Not Throw
            }

            It 'Should return the correct hashtable property' {
                $script:getTargetResourceResult.CSVPath | Should Not Be $script:csvPath
            }

            It 'Should call expected Mocks' {    
                Assert-VerifiableMocks
                Assert-MockCalled -CommandName Invoke-SecurityCmdlet -Exactly 1
            } 
        }

        Describe "$($script:DSCResourceName)\Test-TargetResource" {

            # Create the desired auditpol backup file to test against. 
            @(@("Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value")
            @(",System,IPsec Driver,{0CCE9213-69AE-11D9-BED3-505054503030},Success,,1")
            @(",System,System Integrity,{0CCE9212-69AE-11D9-BED3-505054503030},Failure,,2")
            @(",System,Security System Extension,{0CCE9211-69AE-11D9-BED3-505054503030},No Auditing,,0")
            @(",,Option:CrashOnAuditFail,,Enabled,,1")
            @(",,RegistryGlobalSacl,,,,")) | Out-File $script:desiredAuditpolicyCsv -Encoding utf8 -Force

            Context 'CSVs are different' {

                Mock -CommandName Get-TargetResource -MockWith { 
                    return @{CsvPath=$script:currentAuditpolicyCsv} 
                } -Verifiable
                
                Mock -CommandName Remove-BackupFile -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { 
                        $script:testTargetResourceResult = Test-TargetResource -CsvPath $script:csvPath `
                                                                               -IsSingleInstance 'Yes'
                    } | Should Not Throw
                }            

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-TargetResource -Exactly 1
                    Assert-MockCalled -CommandName Remove-BackupFile  -Exactly 1
                } 
            }

            Context 'CSVs are the same' {

                Mock -CommandName Get-TargetResource -MockWith { 
                    return @{CsvPath=$script:desiredAuditpolicyCsv} 
                } -Verifiable
                
                Mock -CommandName Remove-BackupFile -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { 
                        $script:testTargetResourceResult = Test-TargetResource -CsvPath $script:csvPath `
                                                                               -IsSingleInstance 'Yes'
                    } | Should Not Throw
                }            

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {    
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-TargetResource -Exactly 1
                    Assert-MockCalled -CommandName Remove-BackupFile  -Exactly 1
                } 
            }
        }

        Describe "$($script:DSCResourceName)\Set-TargetResource" {

            Mock -CommandName Invoke-SecurityCmdlet -ParameterFilter { $Action -eq 'Import' } `
                 -MockWith { } -Verifiable

            It 'Should not throw an exception' {
                { 
                    $script:setTargetResourceResult = Set-TargetResource -CsvPath $script:csvPath `
                                                                         -IsSingleInstance 'Yes'
                } | Should Not Throw
            }            

            It 'Should not return anything' {
                $script:setTargetResourceResult | Should BeNullOrEmpty
            }

            It 'Should call expected Mocks' {
                Assert-VerifiableMocks
                Assert-MockCalled -CommandName Invoke-SecurityCmdlet -Exactly 1 -Scope Describe
            }
        }

        Describe 'Function Invoke-SecurityCmdlet' {
            
            # Create function to mock since security cmdlets are not in appveyor 
            function Restore-AuditPolicy { }
            function Backup-AuditPolicy { }   

            Context 'Backup when security cmdlets are available' {

                Mock -CommandName Get-Module -ParameterFilter { $Name -eq "SecurityCmdlets"} `
                     -MockWith {"SecurityCmdlets"} -Verifiable

                Mock -CommandName Import-Module -ParameterFilter { $Name -eq "SecurityCmdlets"}

                Mock -CommandName Backup-AuditPolicy -MockWith {} -Verifiable
                
                It 'Should not throw an exception' {
                    { 
                        $script:backupAuditPolicyResult = Invoke-SecurityCmdlet -Action Export `
                                                          -CsvPath $script:currentAuditpolicyCsv 
                    } | Should Not Throw
                }            

                It 'Should not return anything' {
                    $script:backupAuditPolicyResult | Should BeNullOrEmpty
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-Module         -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Import-Module      -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Backup-AuditPolicy -Exactly 1 -Scope Context
                }
            }
            
            Context 'Restore when security cmdlets are available' {

                Mock -CommandName Get-Module -ParameterFilter { $Name -eq "SecurityCmdlets"} `
                     -MockWith {"SecurityCmdlets"} -Verifiable
                
                Mock -CommandName Import-Module -ParameterFilter { $Name -eq "SecurityCmdlets"}

                Mock -CommandName Restore-AuditPolicy -MockWith {} -Verifiable
                
                It 'Should not throw an exception' {
                { $script:restoreAuditPolicyResult = Invoke-SecurityCmdlet -Action Import `
                                                        -CsvPath $script:currentAuditpolicyCsv } | 
                    Should Not Throw
                }            

                It 'Should not return anything' {
                    $script:restoreAuditPolicyResult | Should BeNullOrEmpty
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-Module          -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Import-Module       -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Restore-AuditPolicy -Exactly 1 -Scope Context
                }
            }

            Context 'Backup when security cmdlets are NOT available' {

                Mock -CommandName Get-Module -ParameterFilter { $Name -eq "SecurityCmdlets" } `
                     -MockWith {} -Verifiable
                
                Mock -CommandName Invoke-AuditPol -ParameterFilter { $Command -eq "Backup" } `
                     -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                { $script:backupAuditPolicyResult = Invoke-SecurityCmdlet -Action Export `
                                                        -CsvPath $script:currentAuditpolicyCsv } | 
                    Should Not Throw
                }            

                It 'Should not return anything' {
                    $script:backupAuditPolicyResult | Should BeNullOrEmpty
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-Module      -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Invoke-AuditPol -Exactly 1 -Scope Context
                }
            }

            Context 'Restore when security cmdlets are NOT available' {

                Mock -CommandName Get-Module -ParameterFilter { $Name -eq "SecurityCmdlets" } `
                     -MockWith {} -Verifiable
                
                Mock -CommandName Invoke-AuditPol -ParameterFilter { $Command -eq "Restore" } `
                     -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                { $script:restoreAuditPolicyResult = Invoke-SecurityCmdlet -Action Import `
                                                        -CsvPath $script:currentAuditpolicyCsv } | 
                    Should Not Throw
                }            

                It 'Should not return anything' {
                    $script:restoreAuditPolicyResult | Should BeNullOrEmpty
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Get-Module      -Exactly 1 -Scope Context
                    Assert-MockCalled -CommandName Invoke-AuditPol -Exactly 1 -Scope Context
                }
            }
        }

        Describe 'Function Remove-BackupFile' {

            $script:csvPath = $script:currentAuditpolicyCsv

            Mock -CommandName Remove-Item -ParameterFilter { $Path -eq $script:currentAuditpolicyCsv} `
                -MockWith { } -Verifiable

            It 'Should call Remove-Item to clean up temp file' {
                Remove-BackupFile -CsvPath $script:csvPath | Should BeNullOrEmpty
                Assert-MockCalled -CommandName Remove-Item -Times 1 -Scope Describe
            }

            It 'Should call expected Mocks' {
                    Assert-VerifiableMocks
                    Assert-MockCalled -CommandName Remove-Item -Times 1 -Scope Describe
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
