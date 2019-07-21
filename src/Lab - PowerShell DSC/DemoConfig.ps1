configuration DemoConfig {

    Import-DscResource -ModuleName NetworkingDSC
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node 'localhost' {
        
        Firewall 'FirewallSettingOne' {
            Name      = 'Demo Block Rule'
            Action    = 'Block'
            LocalPort = 5000
            Protocol  = 'TCP'
            Enabled   = 'True'
            Direction = 'Inbound'
            Profile   = 'Any'
        }

        Registry 'ConsentPromptBehaviorAdmin' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'ConsentPromptBehaviorAdmin'
            ValueType = 'Dword'
            ValueData = '2'
        }

        Registry 'PromptOnSecureDesktop' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'PromptOnSecureDesktop'
            ValueType = 'Dword'
            ValueData = '1'
        }
    }
}