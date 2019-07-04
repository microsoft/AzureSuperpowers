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

$script:categories = @()
$script:subcategories = @()

auditpol /list /subcategory:* | 
Where-Object { $_ -notlike 'Category/Subcategory*' } | ForEach-Object `
{
    # The categories do not have any space in front of them, but the subcategories do.
    if ( $_ -notlike " *" )
    {
        $categories += $_.Trim()
    }
    else
    {
        $subcategories += $_.trim()
    }
} 

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

    # Loop through the raw output of every category option to validate the auditpol /category subcommand
    foreach ( $category in $categories ) 
    {
        Context "Category: $category" {
        
            $auditpolCategory = auditpol.exe /get /category:$category /r
          
            It 'Should return an empty string on line 1' {

                $auditpolCategory[1] | Should Be ""
            }

            It 'Should return the category contents on line 2' {

                # the auditpol /r output starts with the computer name on each entry
                $auditpolCategory[2] | Should Match "$env:ComputerName"
            }
        }
    }

    # Loop through the filtered output of every category option to validate the auditpol /category subcommand
    foreach ( $category in $categories ) 
    {
        Context "Category: $category Filtered 'Select-String -Pattern `$env:ComputerName'" {
            # Reuse the same command as the raw output context, only this time filter out the entries.
            # This is to verify the row indexing is not broken in later formatting actions

            $auditpolCategory = auditpol.exe /get /category:$category /r | 
                Select-String -Pattern $env:ComputerName
            $auditpolCategoryCount = ($auditpolCategory | Measure-Object).Count
        
            It 'Should return more than one item' { 
                # The header row has been stripped, so there should be more than one category to 
                # account for multiple subcategories
                $auditpolCategoryCount | Should BeGreaterThan 1
            }

            # Loop through the subcategories returned by the current category that was queried
            for ( $i = 0; $i -lt $auditpolCategoryCount; $i++ )
            {
                It "Should return a subcategory on line $i" {
                    # Verify that each filtered row that is returned, is in the expected format 
                    $auditpolCategory[$i] | Should Match "$env:ComputerName,System,"
                }
            }

            It 'Should return a null on the last line' {
                # With a zero base, the count of the subcategories should index to the end of the list
                $auditpolCategory[$auditpolCategoryCount] | Should BeNullOrEmpty
            }
        }
    }

    # Loop through the raw output of every subcategory to validate the auditpol /subcategory subcommand
    foreach ( $subcategory in $subcategories ) 
    {
        Context "Subcategory: $subcategory" {

            $auditpolSubcategory = auditpol.exe /get /subcategory:$subcategory /r

            It 'Should return an empty string on line 1there should be more than one category to account for multiple subcategories' {
                # Verify the raw auditpol CSV header format has not changed across different OS versions and types. 
                $auditpolSubcategory[1] | Should BeNullOrEmpty
            }
        
            It 'Should return the subcategory on line 2' {
                # Verify the raw auditpol CSV header format has not changed across different OS versions and types. 
                $auditpolSubcategory[2] | Should Match "$env:ComputerName"
            }
        }
    }

    # Loop through the filtered output of every subcategory to validate the auditpol /subcategory subcommand
    foreach ( $subcategory in $subcategories ) 
    {
        Context "Subcategory: $subcategory Filtered 'Select-String -Pattern `$env:ComputerName'" {
            # Reuse the same command as the raw output context, only this time filter out the entries.
            # This is to verify the row indexing is not broken in the formatting function
            $auditpolSubcategory = auditpol.exe /get /subcategory:$subcategory /r | 
                Select-String -Pattern $env:ComputerName

            It 'Should return a single subcategory' {
                # Verify the raw auditpol CSV header format has not changed across different OS versions and types. 
                ($auditpolSubcategory | Measure-Object).Count | Should Be 1
            }

            It 'Should return the Subcategory on line 0' {
                # Verify that each filtered row that is returned is in the expected format 
                $auditpolSubcategory[0] | Should Match "$env:ComputerName,System,"
           }

            It 'Should return null on line 1' {
                # Verify the raw auditpol CSV header format has not changed across different OS versions and types. 
                $auditpolSubcategory[1]| Should BeNullOrEmpty
            }
        }
    }
}

Describe "Function Invoke-Auditpol" {

    InModuleScope AuditPolicyResourceHelper {
        
        Context 'Subcategory and Option' {

            # These tests verify that the /r switch is passed to auditpol 
            It 'Should return a CSV format when a single word subcategory is passed in' {
                ( Invoke-Auditpol -Command "Get" -SubCommand "Subcategory:Logoff" )[0] | 
                    Should match ".,."
            }

            It 'Should return a CSV format when a multi-word subcategory is passed in' {
                ( Invoke-Auditpol -Command "Get" -SubCommand "Subcategory:""Credential Validation""" )[0] | 
                    Should match ".,."
            }

            It 'Should return a CSV format when an option is passed in' {
                ( Invoke-Auditpol -Command "Get" -SubCommand "option:CrashOnAuditFail" )[0] | 
                    Should match ".,."
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
