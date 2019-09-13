configuration 'MSFT_AuditPolicyGUID_Config'
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $AuditFlag,

        [Parameter(Mandatory = $true)]
        [String]
        $AuditFlagEnsure
    )

    Import-DscResource -ModuleName 'AuditPolicyDsc'

    node localhost
    {
        AuditPolicyGUID Integration_Test
        {
            Name      = $Name
            AuditFlag = $AuditFlag
            Ensure    = $AuditFlagEnsure
        }
    }
}
