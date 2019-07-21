<#
    This example will enable Base Directory auditing on the localhost. 
    To use this example, run it using PowerShell.
#>
Configuration Sample_AuditOption
{
    param
    (
        [String] $NodeName = 'localhost'
    )    
   
    Import-DscResource -ModuleName AuditPolicyDsc

    Node $NodeName
    {
        AuditPolicyOption AuditBaseDirectories
        {
            Name  = 'AuditBaseDirectories'
            Value = 'Enabled'
        }
    }
}

Sample_AuditOption
