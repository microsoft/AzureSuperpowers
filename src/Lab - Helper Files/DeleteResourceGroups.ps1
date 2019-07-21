#Login
Login-AzAccount
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"

#Login - MAG
Login-AzAccount -Environment AzureUSGovernment
Get-AzSubscription
Select-AzSubscription -Subscription "Desired Subscription Name"

#Get all Azure Resource Groups and delete any resources groups with 0 resources 
$rgs = Get-AzResourceGroup
     
if (!$rgs) { 
    Write-Output "No resource groups in your subscription" 
} 
else { 
         
    Write-Output "You have $($(Get-AzResourceGroup).Count) resource groups in your subscription" 
         
    foreach ($resourceGroup in $rgs) { 
        $name = $resourceGroup.ResourceGroupName
        $count = (Get-AzResource | where { $_.ResourceGroupName -match $name }).Count
        if ($count -eq 0) { 
            Write-Output "The resource group $name has $count resources. Deleting it..."
            Remove-AzResourceGroup -Name $name -Force
        } 
        else { 
            Write-Output "The resource group $name has $count resources"
        } 
    } 
         
    Write-Output "Now you have $((Get-AzResourceGroup).Count) resource group(s) in your subscription"
         
}   