#Login
Login-AzAccount
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"
New-AzResourceGroup -Name 'AzSuperADLAB-<YOURALIAS>' -Location 'eastus'

#Login - MAG
Login-AzAccount -Environment AzureUSGovernment
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"
New-AzResourceGroup -Name 'AzSuperADLAB-<YOURALIAS>' -Location 'usgovvirginia'

<#
This template will take approximately 1 hour to deploy
When you execute the deployment, it will prompt you for the following 3 values.  Use the values below.
    VMadminUsername: admuser
    VMadminPassword: <Define a complex password, capture it so you can use it to login>
    numberOfvmWorkerInstances: 3
#>

<#
Highlight lines 31 to 40 below
Press F8 to execute.  Enter values for the parameters as listed above.
This will run the Test-AzResourceGroupDeployment with the parameters stored within $DeploymentParametersBuildVM
You should receive notice that the template is valid.
Execute line 42.  This will execute New-AzResourceGroupDeployment which will start the deployment.
Enter values for the parameters again, using the same values you used during Test-AzResourceGroupDeployment
This will kick off the deployment, which will take about 1 hour to complete
#>

$DeploymentParametersBuildVM = @{
    ResourceGroupName    = 'AzSuperADLAB-<YOURALIAS>'
    TemplateUri          = 'https://azuresuperpowers.blob.core.windows.net/arm/Exercise1/adLab.json?st=2019-03-27T01%3A54%3A27Z&se=2021-03-28T01%3A54%3A00Z&sp=rl&sv=2018-03-28&sr=b&sig=PP2e8y26iuayYdeyjY5x9dq8gOYR3QDIw%2FWWeyeGC3U%3D'
    Timestamp            = [system.DateTime]::Now.ToString("MM/dd/yyyy H:mm:ss tt")
    CreateWorkerNodes    = 'true'
    FullPathToFile       = 'https://azuresuperpowers.blob.core.windows.net/arm/Exercise1/CustomScriptExtensionFiles/CheckForAD/CheckForAD.ps1?st=2019-03-27T01%3A55%3A14Z&se=2021-03-28T01%3A55%3A00Z&sp=rl&sv=2018-03-28&sr=b&sig=ku9y0cpYebgB7fmfVMTT4kpOCjKEjzaEqoZOs3xDKpg%3D'
    FileNameAndExtension = '.\Exercise1\CustomScriptExtensionFiles\CheckForAD\CheckForAD.ps1'
    Verbose              = $true
}
Test-AzResourceGroupDeployment @DeploymentParametersBuildVM

New-AzResourceGroupDeployment @DeploymentParametersBuildVM