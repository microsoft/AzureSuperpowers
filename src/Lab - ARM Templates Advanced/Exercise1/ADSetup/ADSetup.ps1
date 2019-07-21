configuration CreateADPDC 
{ 
    param 
    ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

        [Int]$RetryCount = 5,
        [Int]$RetryIntervalSec = 10
    ) 
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory
    
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        WindowsFeature 'ADDSInstall' { 
            Name = "AD-Domain-Services" 
        }

        xADDomain FirstDC
        {
            DomainName                    = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DependsOn                     = "[WindowsFeature]ADDSInstall"
        } 

        LocalConfigurationManager {
            ConfigurationMode  = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
    }
} 

configuration JoinAD 
{ 
    param 
    ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds
    ) 
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory, xDSCDomainJoin
    
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        xDSCDomainJoin "Join$Domain"
        {
            Domain     = $DomainName
            Credential = $DomainCreds
        }

        LocalConfigurationManager {
            ConfigurationMode  = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
    }
} 