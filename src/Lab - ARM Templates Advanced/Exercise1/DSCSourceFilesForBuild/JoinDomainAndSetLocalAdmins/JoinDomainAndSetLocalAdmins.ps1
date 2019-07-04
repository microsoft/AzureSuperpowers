Configuration JoinDomainAndSetLocalAdmins
{
    param(
        [Parameter(HelpMessage='The group in the domain to add')]
        [string]$DomainGroup,
        [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeply DSC resources because the parameters have changed.')]
        [string]$Timestamp
        )


    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    
    Node localhost
    
    {
        Script 'JoinDomainAndSetLocalAdmins' {
            GetScript  = {
                @{
                    Members = Get-LocalGroupMember -Name Administrators
                }
            }
            TestScript = {
                $LocalAdmins = Get-LocalGroupMember -Name Administrators | Where-Object {$_.ObjectClass -eq 'Group' -and $_.PrincipalSource -eq 'ActiveDirectory'}
                $AdminGroupNames = $LocalAdmins.name | ForEach-Object {$_.split('\')[-1]}
                $AdminGroupNames -contains "$using:DomainGroup"
            }
            SetScript  = {
                Add-LocalGroupMember -Group "Administrators" -Member $using:DomainGroup
            }
        }   
    }
}