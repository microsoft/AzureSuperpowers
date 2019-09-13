#requires -RunAsAdministrator

# Get the root path of the resourse
[String] $script:moduleRoot = Split-Path -Parent ( Split-Path -Parent $PSScriptRoot )

Import-Module -Name (Join-Path -Path $moduleRoot `
                               -ChildPath 'DSCResources\AuditPolicyResourceHelper\AuditPolicyResourceHelper.psm1' ) `
                               -Force
#region Generate data

<#
    The auditpol utility outputs the list of categories and subcategories in a couple of different
    ways. Using the /list flag only returns the categories without the associated audit setting,
    so it is easier to filter later on.
#>

$script:subcategories = auditpol /get /category:* /R | ConvertFrom-Csv

#endregion

Describe 'Prerequisites' {

    # There are several dependencies for both Pester and AuditPolicyDsc that need to be validated.
    It "Should be running as admin" {
        # The tests need to run as admin to have access to the auditpol data
        ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator") | Should Be $true
    }

    It "Should find auditpol.exe in System32" {
        # If the auditpol is not located on the system, the entire module will fail
        Test-Path "$env:SystemRoot\system32\auditpol.exe" | Should Be $true
    }
}

Describe 'auditpol.exe output' {

    # Verify the raw auditpol output format has not changed across different OS versions and types.
    It 'Should get auditpol default return with no parameters' {
        ( auditpol.exe )[0] | Should BeExactly 'Usage: AuditPol command [<sub-command><options>]'
    }

    It 'Should get CSV format with the /r switch' {
        ( auditpol.exe /get /subcategory:logon /r )[0] |
        Should BeExactly "Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting"
    }

    foreach ( $subcategory in $script:subcategories )
    {
        Context "Subcategory: $($subcategory.subcategory)" {

            $auditpolSubcategory = auditpol.exe /get /subcategory:$($subcategory.subcategory) /r | ConvertFrom-Csv

            It 'Should return the subcategory name' {
                $auditpolSubcategory.subcategory | Should Be $subcategory.subcategory
            }
            It 'Should return the subcategory GUID' {
                $auditpolSubcategory.'subcategory GUID' | Should Be $subcategory.'subcategory GUID'
            }
            It 'Should return the Inclusion Setting' {
                $auditpolSubcategory.'Inclusion Setting' | Should Be $subcategory.'Inclusion Setting'
            }
        }
    }
}

Describe "Function Invoke-Auditpol" {

    InModuleScope AuditPolicyResourceHelper {

        Context 'Subcategory and Option' {

            # These tests verify that an object is returned from Invoke-Auditpol
            It 'Should return an object when a single word subcategory is passed in' {
                $subcategory = Invoke-Auditpol -Command "Get" -SubCommand "Subcategory:Logoff"
                $subcategory.Subcategory         | Should Be 'Logoff'
                $subcategory.'Subcategory GUID'  | Should Not BeNullOrEmpty
                $subcategory.'Inclusion Setting' | Should Not BeNullOrEmpty
            }

            It 'Should return an object when a multi-word subcategory is passed in' {
                $subcategory = Invoke-Auditpol -Command "Get" -SubCommand "Subcategory:""Credential Validation"""
                $subcategory.Subcategory | Should Be 'Credential Validation'
                $subcategory.'Subcategory GUID'  | Should Not BeNullOrEmpty
                $subcategory.'Inclusion Setting' | Should Not BeNullOrEmpty
            }

            It 'Should return an object when an option is passed in' {
                $option = Invoke-Auditpol -Command "Get" -SubCommand "option:CrashOnAuditFail"
                $option.Subcategory | Should Be 'option:CrashOnAuditFail'
                $option.'Subcategory GUID'  | Should BeNullOrEmpty
                $option.'Inclusion Setting' | Should Not BeNullOrEmpty
            }
        }

        Context 'Backup' {

            $script:path = ([system.IO.Path]::GetTempFileName()).Replace('tmp','csv')

            It 'Should be able to call Invoke-Audtipol with backup and not throw' {
                {$script:auditpolBackupReturn = Invoke-AuditPol -Command 'Backup' `
                                                                -SubCommand "file:$script:path"} |
                    Should Not Throw
            }

            It 'Should not return anything when a backup is requested' {
                $script:auditpolBackupReturn | Should BeNullOrEmpty
            }

            It 'Should produce a valid CSV in a temp file when the backup switch is used' {
                (Get-Content -Path $script:path)[0] |
                    Should BeExactly "Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value"
            }
        }

        Context 'Restore' {

            It 'Should be able to call Invoke-Audtipol with backup and not throw' {
                {$script:auditpolRestoreReturn = Invoke-AuditPol -Command 'Restore' `
                                                                 -SubCommand "file:$script:path"} |
                    Should Not Throw
            }

            It 'Should not return anything when a restore is requested' {
                $script:auditpolRestoreReturn | Should BeNullOrEmpty
            }
        }
    }
}

Describe 'Test-ValidSubcategory' {

    InModuleScope AuditPolicyResourceHelper {

        Context 'Invalid Input' {

            It 'Should not throw an exception' {
                { $script:testValidSubcategoryResult = Test-ValidSubcategory -Name 'Invalid' } |
                    Should Not Throw
            }

            It 'Should return false when an invalid Subcategory is passed ' {
                $script:testValidSubcategoryResult | Should Be $false
            }
        }

        Context 'Valid Input' {

            It 'Should not throw an exception' {
                { $script:testValidSubcategoryResult = Test-ValidSubcategory -Name 'logon' } |
                    Should Not Throw
            }

            It 'Should return true when a valid Subcategory is passed ' {
                $script:testValidSubcategoryResult | Should Be $true
            }
        }
    }
}
