<#
    This example will apply the audit policy settings in the CSV located at 
    C:\data\AuditPolBackup.csv to the localhost. 
    To use this example, run it using PowerShell.
#>
Configuration Sample_AuditPolicyCsv
{
    param
    (
        [String] $NodeName = 'localhost'
    )    
   
    Import-DscResource -ModuleName AuditPolicyDsc

    Node $NodeName
    {
        AuditPolicyCsv auditPolicy
        {
            IsSingleInstance = 'Yes'
            CsvPath = "C:\data\AuditPolBackup.csv"
        }
    }
}

Sample_AuditPolicyCsv
