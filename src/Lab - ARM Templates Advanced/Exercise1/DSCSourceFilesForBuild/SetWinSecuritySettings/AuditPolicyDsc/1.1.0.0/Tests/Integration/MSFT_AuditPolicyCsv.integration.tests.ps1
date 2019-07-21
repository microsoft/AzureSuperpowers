
$script:DSCModuleName      = 'AuditPolicyDsc'
$script:DSCResourceName    = 'MSFT_AuditPolicyCsv'

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

# Using try/finally to always cleanup even if something awful happens.
try
{
    #region Integration Tests
    $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCResourceName).config.ps1"
    . $ConfigFile 

    Describe "$($script:DSCResourceName)_Integration" {
        
        Context 'Should set policy' {

            # set the system Subcategories to the incorect state to ensure a valid test.
            & 'auditpol' '/set' "/subcategory:Credential Validation" '/failure:disable' '/Success:enable'
            & 'auditpol' '/set' "/subcategory:Other Account Management Events" '/failure:enable' '/Success:disable'
            & 'auditpol' '/set' "/subcategory:Logoff" '/failure:enable' '/Success:disable'
            & 'auditpol' '/set' "/subcategory:Logon" '/failure:enable' '/Success:enable'
            & 'auditpol' '/set' "/subcategory:Special Logon" '/failure:disable' '/Success:enable'
            <# 
                Since the tests read in CSV files, they are stored in a subfolder for the user and
                system context to both access.
            #> 
            $csvPath = ([system.IO.Path]::GetTempFileName()).Replace('.tmp','.csv')

            # Create the desired auditpol backup file to test with. 
            @(@("Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value")
            @(",System,Credential Validation,{0cce923f-69ae-11d9-bed3-505054503030},Success and Failure,,3")
            @(",System,Other Account Management Events,{0cce923a-69ae-11d9-bed3-505054503030},Success and Failure,,3")
            @(",System,Logoff,{0cce9216-69ae-11d9-bed3-505054503030},Success,,1")
            @(",System,Logon,{0cce9215-69ae-11d9-bed3-505054503030},Success and Failure,,3")
            @(",System,Special Logon,{0cce921b-69ae-11d9-bed3-505054503030},Failure,,2")) | 
                Out-File $csvPath -Encoding utf8 -Force
            #region DEFAULT TESTS

            It 'Should compile and apply the MOF without throwing' {
                {
                    & "$($script:DSCResourceName)_Config" -CsvPath $csvPath `
                                                          -OutputPath $TestDrive
                    
                    Start-DscConfiguration -Path $TestDrive `
                        -ComputerName localhost -Wait -Verbose -Force
                } | Should not throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { $script:currentConfig = Get-DscConfiguration -Verbose -ErrorAction Stop } | 
                    Should Not throw
            }

            It 'Should have added Failure flag when configured for Success only' {
                $auditpolReturn = (& 'auditpol' '/get' '/subcategory:Credential Validation' '/r')[2] 
                ($auditpolReturn -split ",")[4] | Should Be "Success and Failure"
            }

            It 'Should have added Success flag when configured for Failure only' {
                $auditpolReturn = (& 'auditpol' '/get' '/subcategory:Other Account Management Events' '/r')[2] 
                ($auditpolReturn -split ",")[4] | Should Be "Success and Failure"
            }

            It 'Should have removed Failure flag and added Success flag' {
                $auditpolReturn = (& 'auditpol' '/get' '/subcategory:Logoff' '/r')[2] 
                ($auditpolReturn -split ",")[4] | Should Be "Success"
            }

            It 'Should have removed Success flag and added Failure flag' {
                $auditpolReturn = (& 'auditpol' '/get' '/subcategory:Special Logon' '/r')[2] 
                ($auditpolReturn -split ",")[4] | Should Be "Failure"
            }

            It 'Should have not made any changes when configured correctly' {
                $auditpolReturn = (& 'auditpol' '/get' '/subcategory:Logon' '/r')[2] 
                ($auditpolReturn -split ",")[4] | Should Be "Success and Failure"
            }
            #endregion
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
