<#
    This example will set the Logon Success and Failure flags on the localhost. 
    To use this example, run it using PowerShell.
#>
Configuration Sample_AuditSubcategory
{
    param
    (
        [String] $NodeName = 'localhost'
    )    
   
    Import-DscResource -ModuleName AuditPolicyDsc

    Node $NodeName
    {
        AuditPolicySubcategory LogonSuccess
        {
            Name      = 'Logon'
            AuditFlag = 'Success'
            Ensure    = 'Absent' 
        } 

        AuditPolicySubcategory LogonFailure
        {
            Name      = 'Logon'
            AuditFlag = 'Failure'
            Ensure    = 'Present'
        }
    }
}

Sample_AuditSubcategory
