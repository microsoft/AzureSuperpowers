
$script:DSCModuleName   = 'AuditPolicyDsc'
$script:DSCResourceName = 'MSFT_AuditPolicyGUID'

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

        Describe "$($script:DSCResourceName)\Get-TargetResource" {

            $testParameters = @{
                Name      = 'Logon'
                AuditFlag = 'Success'
            }

            Context "Subcategory submit 'Success' and return 'Success'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Present'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Success' and return 'Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties from a Subcategory' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Success' and return 'No Auditing'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['No Auditing'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'No Auditing'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Success' and return 'Success And Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success And Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success And Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.AuditFlag = 'Failure'

            Context "Subcategory submit 'Failure' and return 'Success'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Failure' and return 'Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties from a Subcategory' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Present'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Failure' and return 'No Auditing'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['No Auditing'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'No Auditing'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Subcategory submit 'Failure' and return 'Success And Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success And Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success And Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.Name      = 'Credential Validation'
            $testParameters.AuditFlag = 'Success'

            Context "Mulit-word subcategory submit 'Success' and return 'Success'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Present'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Success' and return 'Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Success' and return 'No Auditing'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['No Auditing'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'No Auditing'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Success' and return 'Success And Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success And Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success And Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.AuditFlag = 'Failure'

            Context "Mulit-word subcategory submit 'Failure' and return 'Success'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Failure' and return 'Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties from a Subcategory' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Present'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Failure' and return 'No Auditing'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['No Auditing'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'No Auditing'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context "Mulit-word subcategory submit 'Failure' and return 'Success And Failure'" {

                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success And Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:getTargetResourceResult = Get-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return the correct hashtable properties' {
                    $script:getTargetResourceResult.Name      | Should Be $testParameters.Name
                    $script:getTargetResourceResult.AuditFlag | Should Be 'Success And Failure'
                    $script:getTargetResourceResult.Ensure    | Should Be 'Absent'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }
        }

        Describe "$($script:DSCResourceName)\Test-TargetResource" {

            $testParameters = @{
                Name      = 'Invalid'
                AuditFlag = 'Success'
                Ensure    = 'Present'
            }

            Context 'Invalid subcategory' {

                Mock -CommandName Get-AuditSubCategory -MockWith { } `
                     -ModuleName MSFT_AuditPolicyGUID

                It 'Should throw an exception' {
                    { $getTargetResourceResult = Get-TargetResource @testParameters } | Should Throw
                }

                It 'Should NOT call expected Mocks' {
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Times 0
                }
            }

            # Update the Subcategory to a valid name
            $testParameters.Name = 'Logon'

            Context 'Subcategory Success flag present and should be' {
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context 'Subcategory Success flag present and should not be' {

                $testParameters.Ensure = 'Absent'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.AuditFlag   = 'Failure'

            Context 'Subcategory failure flag present and should be' {

                $testParameters.Ensure = 'Present'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } |
                        Should Not Throw
                }

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context 'Subcategory failure flag present and should not be' {

                $testParameters.Ensure = 'Absent'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.AuditFlag   = 'Success'
            $testParameters.Name = 'Credential Validation'

            Context 'Multi-word subcategory Success flag present and should be' {

                $testParameters.Ensure = 'Present'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } |  Should Not Throw
                }

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context 'Multi-word subcategory Success flag present and should not be' {

                $testParameters.Ensure = 'Absent'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Success'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            $testParameters.AuditFlag   = 'Failure'

            Context 'Multi-word subcategory failure flag present and should be' {

                $testParameters.Ensure = 'Present'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return true' {
                    $script:testTargetResourceResult | Should Be $true
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }

            Context 'Multi-word subcategory failure flag present and should not be' {

                $testParameters.Ensure = 'Absent'
                Mock -CommandName Get-AuditSubCategory -MockWith { return $AuditFlagToSettingValue['Failure'] } `
                     -ModuleName MSFT_AuditPolicyGUID -Verifiable

                It 'Should not throw an exception' {
                    { $script:testTargetResourceResult = Test-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should return false' {
                    $script:testTargetResourceResult | Should Be $false
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-AuditSubCategory -Exactly 1
                }
            }
        }

        Describe "$($script:DSCResourceName)\Set-TargetResource" {

            $testParameters = @{
                Name      = 'Logon'
                AuditFlag = 'Success'
                Ensure    = 'Present'
            }

            Context 'Set Subcategory success flag to present' {

                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set Subcategory failure flag to present' {

                $testParameters.AuditFlag = 'Failure'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set Subcategory success flag to absent' {

                $testParameters.Ensure    = 'Absent'
                $testParameters.AuditFlag = 'Success'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set Subcategory failure flag to absent' {

                $testParameters.AuditFlag = 'Failure'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set multi-word subcategory success flag to present' {

                $testParameters.Name      = 'Credential Validation'
                $testParameters.AuditFlag = 'Success'
                $testParameters.Ensure    = 'Present'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set multi-word subcategory failure flag to present' {

                $testParameters.AuditFlag = 'Failure'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set Subcategory success flag to absent' {

                $testParameters.AuditFlag = 'Success'
                $testParameters.Ensure    = 'Absent'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }

            Context 'Set Subcategory failure flag to absent' {

                $testParameters.AuditFlag = 'Failure'
                Mock -CommandName Set-AuditSubcategory -MockWith { } -Verifiable

                It 'Should not throw an exception' {
                    { Set-TargetResource @testParameters } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Set-AuditSubcategory -Exactly 1
                }
            }
        }

        Describe 'Function Get-AuditSubCategory'  {

            [String] $subCategory = 'Logon'
            [GUID] $GUID = $AuditSubcategoryToGUIDHash[$subCategory]
            [String] $auditFlag   = 'Success'
            [pscustomobject] $stagedCSV = @{
                "Machine Name"=$env:COMPUTERNAME;
                "Policy Target"="System";
                "SubCategory"=$subCategory;
                "SubCategory GUID"=$GUID;
                "Inclusion Setting"=$auditFlag;
                "Exclusion Setting"=$null;
                "Setting Value"=$($AuditFlagToSettingValue[$auditFlag]);
            }

            Context 'Get audit category success flag' {

                [String] $auditFlag   = 'Success'
                $stagedCSV.'Inclusion Setting' = $auditFlag
                $stagedCSV.'Setting Value' = $($AuditFlagToSettingValue[$auditFlag])

                Mock -CommandName Get-StagedAuditPolicyCSV -MockWith { $stagedCSV } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditCategoryResult = Get-AuditSubCategory -GUID $GUID } | Should Not Throw
                }

                It 'Should return the correct value' {
                    $script:getAuditCategoryResult | Should Be $AuditFlagToSettingValue[$auditFlag]
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-StagedAuditPolicyCSV -Exactly 1
                }
            }

            Context 'Get audit category failure flag' {

                [String] $auditFlag   = 'failure'
                $stagedCSV.'Inclusion Setting' = $auditFlag
                $stagedCSV.'Setting Value' = $($AuditFlagToSettingValue[$auditFlag])

                <#
                    The return is 3 lines Header, blank line, data
                    ComputerName,System,Subcategory,GUID,AuditFlags
                 #>
                Mock -CommandName Get-StagedAuditPolicyCSV -MockWith { $stagedCSV } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditCategoryResult = Get-AuditSubCategory -GUID $GUID } | Should Not Throw
                }

                It 'Should return the correct value' {
                    $script:getAuditCategoryResult | Should Be $AuditFlagToSettingValue[$auditFlag]
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-StagedAuditPolicyCSV -Exactly 1
                }
            }

            [String] $subCategory = 'Credential Validation'

            Context 'Get audit category success flag' {

                [String] $auditFlag   = 'Success'
                $stagedCSV.'Inclusion Setting' = $auditFlag
                $stagedCSV.'Setting Value' = $($AuditFlagToSettingValue[$auditFlag])

                # the return is 3 lines Header, blank line, data
                # ComputerName,System,Subcategory,GUID,AuditFlags
                Mock -CommandName Get-StagedAuditPolicyCSV -MockWith { $stagedCSV } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditCategoryResult = Get-AuditSubCategory -GUID $GUID } |Should Not Throw
                }

                It 'Should return the correct value' {
                    $script:getAuditCategoryResult | Should Be $AuditFlagToSettingValue[$auditFlag]
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-StagedAuditPolicyCSV -Exactly 1
                }
            }

            Context 'Get audit category failure flag' {

                [String] $auditFlag   = 'failure'
                $stagedCSV.'Inclusion Setting' = $auditFlag
                $stagedCSV.'Setting Value' = $($AuditFlagToSettingValue[$auditFlag])

                # the return is 3 lines Header, blank line, data
                # ComputerName,System,Subcategory,GUID,AuditFlags
                Mock -CommandName Get-StagedAuditPolicyCSV -MockWith { $stagedCSV } -Verifiable

                It 'Should not throw an exception' {
                    { $script:getAuditCategoryResult = Get-AuditSubCategory -GUID $GUID } | Should Not Throw
                }

                It 'Should return the correct value' {
                    $script:getAuditCategoryResult | Should Be $AuditFlagToSettingValue[$auditFlag]
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-StagedAuditPolicyCSV -Exactly 1
                }
            }
        }

        Describe 'Function Set-AuditSubcategory' {

            Context 'Set single word audit category Success flag to Present' {

                Mock -CommandName Write-StagedAuditCSV -MockWith { } -Verifiable

                $command = @{
                    GUID      = $AuditSubcategoryToGUIDHash["Logon"]
                    SettingValue = $AuditFlagToSettingValue["Success"]
                    Ensure    = "Present"
                }

                It 'Should not throw an error' {
                    { Set-AuditSubcategory @command } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Write-StagedAuditCSV -Exactly 1
                }
            }

            Context 'Set single word audit category Success flag to Absent' {

                Mock -CommandName Write-StagedAuditCSV -MockWith { } -Verifiable

                $command = @{
                    GUID      = $AuditSubcategoryToGUIDHash["Logon"]
                    SettingValue = $AuditFlagToSettingValue["Success"]
                    Ensure    = "Absent"
                }

                It 'Should not throw an exception' {
                    { Set-AuditSubcategory @command } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Write-StagedAuditCSV -Exactly 1
                }
            }

            Context 'Set multi-word audit category Success flag to Present' {

                Mock -CommandName Write-StagedAuditCSV -MockWith { } -Verifiable

                $command = @{
                    GUID      = $AuditSubcategoryToGUIDHash["Logon"]
                    SettingValue = $AuditFlagToSettingValue["Success"]
                    Ensure    = "Present"
                }

                It 'Should not throw an exception' {
                    { Set-AuditSubcategory @command } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Write-StagedAuditCSV -Exactly 1
                }
            }

            Context 'Set multi-word audit category Success flag to Absent' {

                Mock -CommandName Write-StagedAuditCSV -MockWith { } -Verifiable

                $command = @{
                    GUID      = $AuditSubcategoryToGUIDHash["Logon"]
                    SettingValue = $AuditFlagToSettingValue["Success"]
                    Ensure    = "Absent"
                }

                It 'Should not throw an exception' {
                    { Set-AuditSubcategory @command } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Write-StagedAuditCSV -Exactly 1
                }
            }
        }

        Describe 'Function Get-StagedAuditPolicyCSV' {
            Copy-Item $(Join-Path $PSScriptRoot "audit.csv") $(Join-Path $env:Temp "audit.csv")
            $file = Get-Item $(Join-Path $PSScriptRoot "audit.csv")
            $path = "file:$(Join-Path $env:Temp "audit.csv")"
            $file.CreationTime = (Get-Date).AddMinutes(-6)

            Mock -CommandName Get-FixedLanguageAuditCSV -MockWith { } -Verifiable -ModuleName AuditPolicyResourceHelper

            Context 'Retrieve stored AuditCSV' {
                It 'Should not throw an error' {
                    { Get-StagedAuditPolicyCSV } | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-FixedLanguageAuditCSV -Exactly 1 -ModuleName AuditPolicyResourceHelper
                }
            }

            Mock -CommandName Remove-Item -MockWith { } -Verifiable -ModuleName AuditPolicyResourceHelper
            Mock -CommandName Invoke-Auditpol -MockWith { } -Verifiable -ParameterFilter { $Command -eq "Backup" } -ModuleName AuditPolicyResourceHelper

            Context "Remove OLD AuditCSV with time stamp: $($file.CreationTime)" {

                It "Should not throw an error" {
                    { Get-StagedAuditPolicyCSV -Path $(Join-Path $PSScriptRoot "audit.csv")} | Should Not Throw
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1 -ModuleName AuditPolicyResourceHelper
                    Assert-MockCalled -CommandName Remove-Item -Exactly 1 -ModuleName AuditPolicyResourceHelper
                    Assert-MockCalled -CommandName Get-FixedLanguageAuditCSV -Exactly 1 -ModuleName AuditPolicyResourceHelper
                }
            }
        }

        Describe 'Function Write-StagedAuditCSV' {
            Copy-Item $(Join-Path $PSScriptRoot "audit.csv") $(Join-Path $env:Temp "audit.csv") -Force

            Context 'Write new CSV data' {

                Mock -CommandName Get-StagedAuditPolicyCSV -MockWith { Get-FixedLanguageAuditCSV $(Join-Path $env:Temp "audit.csv") } -Verifiable -ModuleName AuditPolicyResourceHelper
                Mock -CommandName Invoke-Auditpol -MockWith { } -ParameterFilter { $command -eq "Restore" } -Verifiable -ModuleName AuditPolicyResourceHelper

                $command = @{
                    GUID      = $AuditSubcategoryToGUIDHash["Logon"];
                    SettingValue = $AuditFlagToSettingValue["Success"];
                    Ensure    = "Present";
                }

                It 'Should not throw an error' {
                    { Write-StagedAuditCSV @command } | Should Not Throw
                }

                It "Should update the proper values" {
                    $tmpCSV = Import-CSV $(Join-Path $env:Temp "audit.csv")
                    $updatedValue = $tmpCSV | Where-Object { $_.'Subcategory GUID' -eq "{$($command.GUID)}" }
                    $updatedValue.'Setting Value' | Should Be $command.'SettingValue'
                }

                It 'Should call expected Mocks' {
                    Assert-VerifiableMock
                    Assert-MockCalled -CommandName Get-StagedAuditPolicyCSV -Exactly 1 -ModuleName AuditPolicyResourceHelper
                    Assert-MockCalled -CommandName Invoke-Auditpol -Exactly 1 -ModuleName AuditPolicyResourceHelper
                }
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
