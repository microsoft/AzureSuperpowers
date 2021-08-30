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
    TemplateUri = 'https://azuresuperpowers.blob.core.windows.net/arm/emptyTemplate.json?sv=2020-04-08&st=2021-08-30T17%3A56%3A36Z&se=2031-08-31T17%3A56%3A00Z&sr=b&sp=r&sig=WBwmXkZyKZkiH42cb3grg45h0XI5gJcWXNc91mN3Vlw%3D'
    Verbose     = $true
}
New-AzResourceGroupDeployment @ARMParams