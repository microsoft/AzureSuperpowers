
configuration 'MSFT_AuditPolicyOption_config'
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OptionName,
        
        [Parameter(Mandatory = $true)]
        [System.String]
        $OptionValue
    )

    Import-DscResource -ModuleName 'AuditPolicyDsc'

    node localhost 
    {
        AuditPolicyOption Integration_Test 
        {
            Name  = $OptionName
            Value = $OptionValue
        }
    }
}
