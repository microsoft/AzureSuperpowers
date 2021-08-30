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
    TemplateUri          = 'https://azuresuperpowers.blob.core.windows.net/arm/Exercise1/adLab.json?sv=2020-04-08&st=2021-08-30T17%3A47%3A37Z&se=2031-08-31T17%3A47%3A00Z&sr=b&sp=r&sig=%2F%2Fz01HUeNMZOadyA26eaA28irL2yahmN6foHFXJq3jk%3D'
    Timestamp            = [system.DateTime]::Now.ToString("MM/dd/yyyy H:mm:ss tt")
    CreateWorkerNodes    = 'true'
    FullPathToFile       = 'https://azuresuperpowers.blob.core.windows.net/arm/Exercise1/CustomScriptExtensionFiles/CheckForAD/CheckForAD.ps1?sv=2020-04-08&st=2021-08-30T17%3A50%3A26Z&se=2031-08-31T17%3A50%3A00Z&sr=b&sp=r&sig=Jlezh%2FM3cGOPWjxAbWBpeqpvlb%2BNWXaJhQi1m6ATKpA%3D'
    FileNameAndExtension = '.\Exercise1\CustomScriptExtensionFiles\CheckForAD\CheckForAD.ps1'
    Verbose              = $true
}
Test-AzResourceGroupDeployment @DeploymentParametersBuildVM

New-AzResourceGroupDeployment @DeploymentParametersBuildVM