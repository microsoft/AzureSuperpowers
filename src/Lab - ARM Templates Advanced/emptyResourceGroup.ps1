#Login
Login-AzAccount
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"

#Login - MAG
Login-AzAccount -Environment AzureUSGovernment
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"

#Highlight the lines below and execute.  You will be prompted to provide a Resource Group
#Ensure you have the correct Subscription and Resource Group as this will DELETE ALL RESOURCES in the resource group

#In this case, your resource group should be named AzSuperADLAB if you followed the previous lab

$ARMParams = @{
    Mode        = 'Complete'
    TemplateUri = 'https://azuresuperpowers.blob.core.windows.net/arm/emptyTemplate.json?st=2018-08-01T15%3A56%3A17Z&se=2020-12-31T15%3A56%3A00Z&sp=rl&sv=2018-03-28&sr=b&sig=nKVmkfBMWPBB4rRkeDUBS%2FTvEOiMvpqBAfbaMVAawyY%3D'
    Verbose     = $true
}
New-AzResourceGroupDeployment @ARMParams