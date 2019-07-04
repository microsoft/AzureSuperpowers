Configuration InstallOMSAgent
{
    param(
        [Parameter(HelpMessage='The URI of the zip file containing the OMS agent installation binaries.')]
        [string]$OMSAgentZipUri,
        [String]$OMSWorkspaceId,
        [String]$OMSWorkspaceKey,
        [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeploy DSC resources because the parameters have changed.')]
        [string]$Timestamp
        )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {
        Script 'InstallOMSAgent' {
            GetScript  = {
                @{
                    Result = ((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EE0183F4-3BF8-4EC8-8F7C-44D3BBE6FDF0}').DisplayName)
                }
            }
            TestScript = {
                Write-Verbose 'Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EE0183F4-3BF8-4EC8-8F7C-44D3BBE6FDF0}"'
                Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EE0183F4-3BF8-4EC8-8F7C-44D3BBE6FDF0}'
                Write-Verbose $?
            }
            SetScript  = {
                $OMSAgentPath = "$env:Temp\OMSAgent-80110810"
                $OMSAgentZipFile = "$OMSAgentPath.zip"
                $zipURI = $using:OMSAgentZipUri

                if($zipURI -eq $null) {
                    throw "OMSAgentZipUri param is null"
                }

                Invoke-WebRequest -URI $zipURI -OutFile $OMSAgentZipFile -Verbose

                Expand-Archive -LiteralPath $OMSAgentZipFile -DestinationPath $OMSAgentPath

                $fileloc = Join-Path -Path $OMSAgentPath -Child 'setup.exe'
                Write-Verbose "Launching $fileloc ..."
                $arglist = @('/qn',
                'ADD_OPINSIGHTS_WORKSPACE=1',
                'OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=1',
                'OPINSIGHTS_WORKSPACE_ID='+$using:OMSWorkspaceId,
                'OPINSIGHTS_WORKSPACE_KEY='+$using:OMSWorkspaceKey,
                'AcceptEndUserLicenseAgreement=1')

                Start-Process -FilePath $fileloc -ArgumentList $arglist -Wait
            }
        }   
    }
}