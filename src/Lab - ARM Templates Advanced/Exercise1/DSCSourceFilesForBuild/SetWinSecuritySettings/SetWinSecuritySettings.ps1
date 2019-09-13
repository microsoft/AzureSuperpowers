Configuration SetWinSecuritySettings
{
	param(
	     [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeploy DSC resources because the parameters have changed.')]
          [string]$Timestamp
	)
	
	Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
	Import-DSCResource -ModuleName 'AuditPolicyDSC'
	Import-DSCResource -ModuleName 'SecurityPolicyDSC'
	Node localhost
	{
         Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun'
         {
              ValueName = 'NoDriveTypeAutoRun'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
              ValueData = 255

         }

         Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutorun'
         {
              ValueName = 'NoAutorun'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableAutomaticRestartSignOn'
         {
              ValueName = 'DisableAutomaticRestartSignOn'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy'
         {
              ValueName = 'LocalAccountTokenFilterPolicy'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters\AllowEncryptionOracle'
         {
              ValueName = 'AllowEncryptionOracle'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Biometrics\FacialFeatures\EnhancedAntiSpoofing'
         {
              ValueName = 'EnhancedAntiSpoofing'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Biometrics\FacialFeatures'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds\DisableEnclosureDownload'
         {
              ValueName = 'DisableEnclosureDownload'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation\AllowProtectedCreds'
         {
              ValueName = 'AllowProtectedCreds'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application\MaxSize'
         {
              ValueName = 'MaxSize'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
              ValueData = 32768

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security\MaxSize'
         {
              ValueName = 'MaxSize'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
              ValueData = 196608

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\System\MaxSize'
         {
              ValueName = 'MaxSize'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
              ValueData = 32768

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoAutoplayfornonVolume'
         {
              ValueName = 'NoAutoplayfornonVolume'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoDataExecutionPrevention'
         {
              ValueName = 'NoDataExecutionPrevention'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoHeapTerminationOnCorruption'
         {
              ValueName = 'NoHeapTerminationOnCorruption'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\NoBackgroundPolicy'
         {
              ValueName = 'NoBackgroundPolicy'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}\NoGPOListChanges'
         {
              ValueName = 'NoGPOListChanges'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated'
         {
              ValueName = 'AlwaysInstallElevated'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Installer\EnableUserControl'
         {
              ValueName = 'EnableUserControl'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection\DeviceEnumerationPolicy'
         {
              ValueName = 'DeviceEnumerationPolicy'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation\AllowInsecureGuestAuth'
         {
              ValueName = 'AllowInsecureGuestAuth'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\*\SYSVOL'
         {
              ValueName = '\\*\SYSVOL'
              ValueType = 'String'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
              ValueData = 'RequireMutualAuthentication=1,RequireIntegrity=1'

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\*\NETLOGON'
         {
              ValueName = '\\*\NETLOGON'
              ValueType = 'String'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
              ValueData = 'RequireMutualAuthentication=1,RequireIntegrity=1'

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenCamera'
         {
              ValueName = 'NoLockScreenCamera'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenSlideshow'
         {
              ValueName = 'NoLockScreenSlideshow'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockLogging'
         {
              ValueName = 'EnableScriptBlockLogging'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
              ValueData = 1

         }

         Registry 'DEL_\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging\EnableScriptBlockInvocationLogging'
         {
              ValueName = 'EnableScriptBlockInvocationLogging'
              ValueType = 'String'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
              ValueData = ''
              Ensure = 'Absent'

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnumerateLocalUsers'
         {
              ValueName = 'EnumerateLocalUsers'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnableSmartScreen'
         {
              ValueName = 'EnableSmartScreen'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\ShellSmartScreenLevel'
         {
              ValueName = 'ShellSmartScreenLevel'
              ValueType = 'String'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
              ValueData = 'Block'

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Windows Search\AllowIndexingEncryptedStoresOrItems'
         {
              ValueName = 'AllowIndexingEncryptedStoresOrItems'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowBasic'
         {
              ValueName = 'AllowBasic'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowUnencryptedTraffic'
         {
              ValueName = 'AllowUnencryptedTraffic'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowDigest'
         {
              ValueName = 'AllowDigest'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\AllowBasic'
         {
              ValueName = 'AllowBasic'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\AllowUnencryptedTraffic'
         {
              ValueName = 'AllowUnencryptedTraffic'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\DisableRunAs'
         {
              ValueName = 'DisableRunAs'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Rpc\RestrictRemoteClients'
         {
              ValueName = 'RestrictRemoteClients'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\DisablePasswordSaving'
         {
              ValueName = 'DisablePasswordSaving'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fDisableCdm'
         {
              ValueName = 'fDisableCdm'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fPromptForPassword'
         {
              ValueName = 'fPromptForPassword'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fEncryptRPCTraffic'
         {
              ValueName = 'fEncryptRPCTraffic'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\MinEncryptionLevel'
         {
              ValueName = 'MinEncryptionLevel'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
              ValueData = 3

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PolicyVersion'
         {
              ValueName = 'PolicyVersion'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall'
              ValueData = 538

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DefaultOutboundAction'
         {
              ValueName = 'DefaultOutboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DefaultInboundAction'
         {
              ValueName = 'DefaultInboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\EnableFirewall'
         {
              ValueName = 'EnableFirewall'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\EnableFirewall'
         {
              ValueName = 'EnableFirewall'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DefaultInboundAction'
         {
              ValueName = 'DefaultInboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DefaultOutboundAction'
         {
              ValueName = 'DefaultOutboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\EnableFirewall'
         {
              ValueName = 'EnableFirewall'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DefaultOutboundAction'
         {
              ValueName = 'DefaultOutboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DefaultInboundAction'
         {
              ValueName = 'DefaultInboundAction'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace\AllowWindowsInkWorkspace'
         {
              ValueName = 'AllowWindowsInkWorkspace'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace'
              ValueData = 1

         }

		 <#
         Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft Services\AdmPwd\AdmPwdEnabled'
         {
              ValueName = 'AdmPwdEnabled'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
              ValueData = 1

		 }
		 #>

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest\UseLogonCredential'
         {
              ValueName = 'UseLogonCredential'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel\DisableExceptionChainValidation'
         {
              ValueName = 'DisableExceptionChainValidation'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch\DriverLoadPolicy'
         {
              ValueName = 'DriverLoadPolicy'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch'
              ValueData = 3

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1'
         {
              ValueName = 'SMB1'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\MrxSmb10\Start'
         {
              ValueName = 'Start'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\MrxSmb10'
              ValueData = 4

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters\NoNameReleaseOnDemand'
         {
              ValueName = 'NoNameReleaseOnDemand'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters'
              ValueData = 1

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableICMPRedirect'
         {
              ValueName = 'EnableICMPRedirect'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
              ValueData = 0

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\DisableIPSourceRouting'
         {
              ValueName = 'DisableIPSourceRouting'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
              ValueData = 2

         }

         Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\DisableIPSourceRouting'
         {
              ValueName = 'DisableIPSourceRouting'
              ValueType = 'Dword'
              Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
              ValueData = 2

         }

         AuditPolicySubcategory 'Audit Credential Validation (Success) - Inclusion'
         {
              Name = 'Credential Validation'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Credential Validation (Failure) - Inclusion'
         {
              Name = 'Credential Validation'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Security Group Management (Success) - Inclusion'
         {
              Name = 'Security Group Management'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Security Group Management (Failure) - Inclusion'
         {
              Name = 'Security Group Management'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit User Account Management (Success) - Inclusion'
         {
              Name = 'User Account Management'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit User Account Management (Failure) - Inclusion'
         {
              Name = 'User Account Management'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit PNP Activity (Success) - Inclusion'
         {
              Name = 'Plug and Play Events'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit PNP Activity (Failure) - Inclusion'
         {
              Name = 'Plug and Play Events'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Process Creation (Success) - Inclusion'
         {
              Name = 'Process Creation'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Process Creation (Failure) - Inclusion'
         {
              Name = 'Process Creation'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Account Lockout (Failure) - Inclusion'
         {
              Name = 'Account Lockout'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

          AuditPolicySubcategory 'Audit Account Lockout (Success) - Inclusion'
         {
              Name = 'Account Lockout'
              Ensure = 'Absent'
              AuditFlag = 'Success'

         }

         AuditPolicySubcategory 'Audit Group Membership (Success) - Inclusion'
         {
              Name = 'Group Membership'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Group Membership (Failure) - Inclusion'
         {
              Name = 'Group Membership'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Logon (Success) - Inclusion'
         {
              Name = 'Logon'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Logon (Failure) - Inclusion'
         {
              Name = 'Logon'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Other Logon/Logoff Events (Success) - Inclusion'
         {
              Name = 'Other Logon/Logoff Events'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Other Logon/Logoff Events (Failure) - Inclusion'
         {
              Name = 'Other Logon/Logoff Events'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Special Logon (Success) - Inclusion'
         {
              Name = 'Special Logon'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Special Logon (Failure) - Inclusion'
         {
              Name = 'Special Logon'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Detailed File Share (Failure) - Inclusion'
         {
              Name = 'Detailed File Share'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

          AuditPolicySubcategory 'Audit Detailed File Share (Success) - Inclusion'
         {
              Name = 'Detailed File Share'
              Ensure = 'Absent'
              AuditFlag = 'Success'

         }

         AuditPolicySubcategory 'Audit File Share (Success) - Inclusion'
         {
              Name = 'File Share'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit File Share (Failure) - Inclusion'
         {
              Name = 'File Share'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Other Object Access Events (Success) - Inclusion'
         {
              Name = 'Other Object Access Events'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Other Object Access Events (Failure) - Inclusion'
         {
              Name = 'Other Object Access Events'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Removable Storage (Success) - Inclusion'
         {
              Name = 'Removable Storage'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Removable Storage (Failure) - Inclusion'
         {
              Name = 'Removable Storage'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Audit Policy Change (Success) - Inclusion'
         {
              Name = 'Audit Policy Change'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Audit Policy Change (Failure) - Inclusion'
         {
              Name = 'Audit Policy Change'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Authentication Policy Change (Success) - Inclusion'
         {
              Name = 'Authentication Policy Change'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Authentication Policy Change (Failure) - Inclusion'
         {
              Name = 'Authentication Policy Change'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit MPSSVC Rule-Level Policy Change (Success) - Inclusion'
         {
              Name = 'MPSSVC Rule-Level Policy Change'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit MPSSVC Rule-Level Policy Change (Failure) - Inclusion'
         {
              Name = 'MPSSVC Rule-Level Policy Change'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Other Policy Change Events (Failure) - Inclusion'
         {
              Name = 'Other Policy Change Events'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

          AuditPolicySubcategory 'Audit Other Policy Change Events (Success) - Inclusion'
         {
              Name = 'Other Policy Change Events'
              Ensure = 'Absent'
              AuditFlag = 'Success'

         }

         AuditPolicySubcategory 'Audit Sensitive Privilege Use (Success) - Inclusion'
         {
              Name = 'Sensitive Privilege Use'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Sensitive Privilege Use (Failure) - Inclusion'
         {
              Name = 'Sensitive Privilege Use'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Other System Events (Success) - Inclusion'
         {
              Name = 'Other System Events'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Other System Events (Failure) - Inclusion'
         {
              Name = 'Other System Events'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Security State Change (Success) - Inclusion'
         {
              Name = 'Security State Change'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Security State Change (Failure) - Inclusion'
         {
              Name = 'Security State Change'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit Security System Extension (Success) - Inclusion'
         {
              Name = 'Security System Extension'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit Security System Extension (Failure) - Inclusion'
         {
              Name = 'Security System Extension'
              Ensure = 'Absent'
              AuditFlag = 'Failure'

         }

         AuditPolicySubcategory 'Audit System Integrity (Success) - Inclusion'
         {
              Name = 'System Integrity'
              Ensure = 'Present'
              AuditFlag = 'Success'

         }

          AuditPolicySubcategory 'Audit System Integrity (Failure) - Inclusion'
         {
              Name = 'System Integrity'
              Ensure = 'Present'
              AuditFlag = 'Failure'

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Debug_programs'
         {
              Policy = 'Debug_programs'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Force_shutdown_from_a_remote_system'
         {
              Policy = 'Force_shutdown_from_a_remote_system'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

		<#
         UserRightsAssignment 'UserRightsAssignment(INF): Deny_log_on_through_Remote_Desktop_Services'
         {
              Policy = 'Deny_log_on_through_Remote_Desktop_Services'
              Force = $True
              Identity = @('*S-1-5-113')

		 }
		 #>

         UserRightsAssignment 'UserRightsAssignment(INF): Lock_pages_in_memory'
         {
              Policy = 'Lock_pages_in_memory'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Take_ownership_of_files_or_other_objects'
         {
              Policy = 'Take_ownership_of_files_or_other_objects'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Access_Credential_Manager_as_a_trusted_caller'
         {
              Policy = 'Access_Credential_Manager_as_a_trusted_caller'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Back_up_files_and_directories'
         {
              Policy = 'Back_up_files_and_directories'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Load_and_unload_device_drivers'
         {
              Policy = 'Load_and_unload_device_drivers'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Impersonate_a_client_after_authentication'
         {
              Policy = 'Impersonate_a_client_after_authentication'
              Force = $True
              Identity = @('*S-1-5-32-544', '*S-1-5-6', '*S-1-5-19', '*S-1-5-20')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Create_a_pagefile'
         {
              Policy = 'Create_a_pagefile'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Modify_firmware_environment_values'
         {
              Policy = 'Modify_firmware_environment_values'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Manage_auditing_and_security_log'
         {
              Policy = 'Manage_auditing_and_security_log'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

		<#
         UserRightsAssignment 'UserRightsAssignment(INF): Deny_access_to_this_computer_from_the_network'
         {
              Policy = 'Deny_access_to_this_computer_from_the_network'
              Force = $True
              Identity = @('*S-1-5-114')

		 }
		 #>

         UserRightsAssignment 'UserRightsAssignment(INF): Profile_single_process'
         {
              Policy = 'Profile_single_process'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Create_global_objects'
         {
              Policy = 'Create_global_objects'
              Force = $True
              Identity = @('*S-1-5-32-544', '*S-1-5-6', '*S-1-5-19', '*S-1-5-20')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Act_as_part_of_the_operating_system'
         {
              Policy = 'Act_as_part_of_the_operating_system'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Restore_files_and_directories'
         {
              Policy = 'Restore_files_and_directories'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Access_this_computer_from_the_network'
         {
              Policy = 'Access_this_computer_from_the_network'
              Force = $True
              Identity = @('*S-1-5-32-544', '*S-1-5-11')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
         {
              Policy = 'Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Create_a_token_object'
         {
              Policy = 'Create_a_token_object'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Create_permanent_shared_objects'
         {
              Policy = 'Create_permanent_shared_objects'
              Force = $True
              Identity = @('')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Allow_log_on_locally'
         {
              Policy = 'Allow_log_on_locally'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         UserRightsAssignment 'UserRightsAssignment(INF): Perform_volume_maintenance_tasks'
         {
              Policy = 'Perform_volume_maintenance_tasks'
              Force = $True
              Identity = @('*S-1-5-32-544')

         }

         SecurityOption 'SecuritySetting(INF): LSAAnonymousNameLookup'
         {
              Name = 'Network_access_Allow_anonymous_SID_Name_translation'
              Network_access_Allow_anonymous_SID_Name_translation = 'Disabled'

         }

         SecurityOption 'SecuritySetting(INF): EnableGuestAccount'
         {
              Accounts_Guest_account_status = 'Disabled'
              Name = 'Accounts_Guest_account_status'

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\EnablePlainTextPassword'
         {
              ValueName = 'EnablePlainTextPassword'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
              ValueData = 0

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\requiresignorseal'
         {
              ValueName = 'requiresignorseal'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\ScRemoveOption'
         {
              ValueName = 'ScRemoveOption'
              ValueType = 'String'
              Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
              ValueData = '1'

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableInstallerDetection'
         {
              ValueName = 'EnableInstallerDetection'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\disablepasswordchange'
         {
              ValueName = 'disablepasswordchange'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 0

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Session Manager\ProtectionMode'
         {
              ValueName = 'ProtectionMode'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableSecureUIAPaths'
         {
              ValueName = 'EnableSecureUIAPaths'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM'
         {
              ValueName = 'RestrictAnonymousSAM'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinServerSec'
         {
              ValueName = 'NTLMMinServerSec'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
              ValueData = 537395200

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorUser'
         {
              ValueName = 'ConsentPromptBehaviorUser'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 0

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictAnonymous'
         {
              ValueName = 'RestrictAnonymous'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\RequireSecuritySignature'
         {
              ValueName = 'RequireSecuritySignature'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\allownullsessionfallback'
         {
              ValueName = 'allownullsessionfallback'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
              ValueData = 0

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\NoLMHash'
         {
              ValueName = 'NoLMHash'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\LmCompatibilityLevel'
         {
              ValueName = 'LmCompatibilityLevel'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 5

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinClientSec'
         {
              ValueName = 'NTLMMinClientSec'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
              ValueData = 537395200

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\SCENoApplyLegacyAuditPolicy'
         {
              ValueName = 'SCENoApplyLegacyAuditPolicy'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin'
         {
              ValueName = 'ConsentPromptBehaviorAdmin'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 2

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\requiresecuritysignature'
         {
              ValueName = 'requiresecuritysignature'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\requirestrongkey'
         {
              ValueName = 'requirestrongkey'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters\RestrictNullSessAccess'
         {
              ValueName = 'RestrictNullSessAccess'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\sealsecurechannel'
         {
              ValueName = 'sealsecurechannel'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\RestrictRemoteSAM'
         {
              ValueName = 'RestrictRemoteSAM'
              ValueType = 'String'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 'O:BAG:BAD:(A;;RC;;;BA)'

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\LDAP\LDAPClientIntegrity'
         {
              ValueName = 'LDAPClientIntegrity'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\LDAP'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\maximumpasswordage'
         {
              ValueName = 'maximumpasswordage'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 30

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA'
         {
              ValueName = 'EnableLUA'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableVirtualization'
         {
              ValueName = 'EnableVirtualization'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Control\Lsa\LimitBlankPasswordUse'
         {
              ValueName = 'LimitBlankPasswordUse'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\FilterAdministratorToken'
         {
              ValueName = 'FilterAdministratorToken'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters\signsecurechannel'
         {
              ValueName = 'signsecurechannel'
              ValueType = 'Dword'
              Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
              ValueData = 1

         }

         Registry 'Registry(INF): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\InactivityTimeoutSecs'
         {
              ValueName = 'InactivityTimeoutSecs'
              ValueType = 'Dword'
              Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
              ValueData = 900

         }

	}
}