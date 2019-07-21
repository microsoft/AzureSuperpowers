Configuration PromoteDC
{
    param(
        [Parameter(HelpMessage='The Domain to Join')]
        [string]$Domain_Name,
        [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeply DSC resources because the parameters have changed.')]
        [string]$Timestamp,
	    [Parameter(Mandatory)]            
        [System.Management.Automation.PSCredentiaal]$Admin_Credentials
        )

        [System.Management.Automation.PSCredential ]$Domain_Credentials = New-Object System.Management.Automation.PSCredential ("${Domain_Name}\$($Admin_Credentials.UserName)", $Admin_Credentials.Password)


    Import-DSCResource -ModuleName PSDesiredStateConfiguration
#comment    
    Node localhost
    
    {
        Script 'PromoteDC' {
            GetScript  = {
                @{
                    Members = Get-LocalGroupMember -Name Administrators
                }
            }
            TestScript = {
                $ServerRole = (get-itemproperty -path HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions).Producttype
                $ServerRole -eq "LanmanNT"
            }
            SetScript  = {
                Install-ADDSDomainController -InstallDns -Credential $Admin_Credentials -DomainName $Domain_Name
            }
        }   
    }
}