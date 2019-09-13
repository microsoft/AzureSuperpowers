<#
    This example will set the Logon Success and Failure flags on the localhost.
    To use this example, run it using PowerShell.
#>
Configuration Sample_AuditPolicyGuid
{
    param
    (
        [String] $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName AuditPolicyDsc

    Node $NodeName
    {
        AuditPolicyGuid LogonSuccess
        {
            Name      = 'Logon'
            AuditFlag = 'Success'
            Ensure    = 'Absent'
        }

        AuditPolicyGuid LogonFailure
        {
            Name      = 'Logon'
            AuditFlag = 'Failure'
            Ensure    = 'Present'
        }
    }
}

Sample_AuditPolicyGuid
