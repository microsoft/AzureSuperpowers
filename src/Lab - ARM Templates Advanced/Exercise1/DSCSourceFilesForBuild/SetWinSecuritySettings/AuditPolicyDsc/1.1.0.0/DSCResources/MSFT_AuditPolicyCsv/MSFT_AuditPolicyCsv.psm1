
Import-Module -Name (Join-Path -Path ( Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
                                                 -ChildPath 'AuditPolicyResourceHelper' ) `
                               -ChildPath 'AuditPolicyResourceHelper.psm1')                         

# Localized messages for Write-Verbose statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_AuditPolicyCsv'

<#
    .SYNOPSIS
        Gets the current audit policy for the node.
    .PARAMETER CsvPath
        This parameter is ignored in the Get operation, but does return the path to the 
        backup of the current audit policy settings. 
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,
        
        [parameter(Mandatory = $true)]
        [System.String]
        $CsvPath
    )
    
    [string] $tempFile = ([system.IO.Path]::GetTempFileName()).Replace('.tmp','.csv')

    try
    {
        Write-Verbose -Message ($localizedData.BackupFilePath -f $tempFile)
        Invoke-SecurityCmdlet -Action "Export" -CsvPath $tempFile
    }
    catch
    {
        Write-Verbose -Message ($localizedData.ExportFailed -f $tempFile)
    }

    return @{
        CsvPath = $tempFile
        IsSingleInstance = 'Yes'
    }
}

<#
    .SYNOPSIS
        Sets the current audit policy for the node.
    .PARAMETER CsvPath
        Specifies the path to desired audit policy settings to apply to the node.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,
        
        [parameter(Mandatory = $true)]
        [System.String]
        $CsvPath
    )

    if (Test-Path -Path $CsvPath)
    {
        try
        {
            Invoke-SecurityCmdlet -Action "Import" -CsvPath $CsvPath | Out-Null
            Write-Verbose -Message ($localizedData.ImportSucceeded -f $CsvPath)    
        }
        catch
        {
            Write-Verbose -Message ($localizedData.ImportFailed -f $CsvPath)
        }
    }
    else
    {
        Write-Verbose -Message ($localizedData.FileNotFound -f $CsvPath)
    }
}

<#
    .SYNOPSIS
        Tests the current audit policy against the desired policy.
    .PARAMETER CsvPath
        Specifies the path to desired audit policy settings to test against the node.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,
        
        [parameter(Mandatory = $true)]
        [System.String]
        $CsvPath
    )

    if (Test-Path -Path $CsvPath)
    {
        # The CsvPath in Get-TargetResource is ignored and a temp file is returned for comparison. 
        $currentAuditPolicyBackupPath = (Get-TargetResource -CsvPath $CsvPath `
                                                            -IsSingleInstance $IsSingleInstance).CsvPath

        $currentAuditPolicy = Import-Csv -Path $currentAuditPolicyBackupPath | 
            Select-Object -Property Subcategory, @{
                'Name' = 'Value';
                'Expression' = {$_.'Setting Value'}
            } 
        
        $desiredAuditPolicy = Import-Csv -Path $CsvPath | 
            Select-Object -Property Subcategory, @{
                'Name' = 'Value';
                'Expression' = {$_.'Setting Value'}
            }
       
       # Assume the node is in the desired state until proven false.
        $inDesiredState = $true

        foreach ($desiredAuditPolicySetting in $desiredAuditPolicy)
        {
            # Get the current setting name that mathches the desired setting name   
            $currentAuditPolicySetting = $currentAuditPolicy.Where({
                $_.Subcategory -eq $desiredAuditPolicySetting.Subcategory
            })

            # If the current and desired setting do not match, set the flag to $false 
            if ($desiredAuditPolicySetting.Value -ne $currentAuditPolicySetting.Value)
            {
                Write-Verbose -Message ($localizedData.testCsvFailed -f 
                    $desiredAuditPolicySetting.Subcategory)
                    
                $inDesiredState = $false
            }
            else 
            {
                Write-Verbose -Message ($localizedData.testCsvSucceed -f 
                    $desiredAuditPolicySetting.Subcategory)
            }
        }

        # Cleanup the temp file, since it is no longer needed. 
        Remove-BackupFile -CsvPath $currentAuditPolicyBackupPath -Verbose

        return $inDesiredState
    }
    else
    {
        Write-Verbose -Message ($localizedData.FileNotFound -f $CsvPath)
        return $false
    }
}

<#
    .SYNOPSIS 
        Helper function to use SecurityCmdlet modules if present. If not, go through AuditPol.exe.
    .PARAMETER Action 
        The action to take, either Import or Export. Import will clear existing policy before writing.
    .PARAMETER CsvPath 
        The path to a CSV file to either create or import.  
    .EXAMPLE
        Invoke-SecurityCmdlet -Action Import -CsvPath .\test.csv
#>
function Invoke-SecurityCmdlet
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet('Import','Export')]
        [System.String]
        $Action,
        
        [Parameter(Mandatory = $true)]
        [System.String]
        $CsvPath 
    )

    # Use the security cmdlets if present. If not, use Invoke-AuditPol to call auditpol.exe.
    if ($null -eq (Get-Module -ListAvailable -Name "SecurityCmdlets"))
    {
        Write-Verbose -Message ($localizedData.CmdletsNotFound)

        if ($Action -ieq "Import")
        {
            Invoke-AuditPol -Command Restore -SubCommand "file:$CsvPath"
        }
        else
        {
            # No force option on Backup, manually check for file and delete it so we can write back again
            if (Test-Path -Path $CsvPath)
            {
                Remove-Item -Path $CsvPath -Force
            }

            Invoke-AuditPol -Command Backup -SubCommand "file:$CsvPath"
        }
    }
    else
    {
        Import-Module -Name SecurityCmdlets

        if ($Action -ieq "Import")
        {
            Restore-AuditPolicy -Path $CsvPath | Out-Null
        }
        elseif ($Action -ieq "Export")
        {
            # No force option on Backup, manually check for file and delete it so we can write back again
            if (Test-Path -Path $CsvPath)
            {
                Remove-Item -Path $CsvPath -Force
            }
            Backup-AuditPolicy -Path $CsvPath | Out-Null
        }
    }
}

<#
    .SYNOPSIS
        Removes the temporary file that is created by the Get\Test functions.
    .PARAMETER CsvPath
        Specifies the path of the temp file to remove.
#>
function Remove-BackupFile
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $CsvPath
    )

    try 
    {
        Remove-Item -Path $CsvPath
        Write-Verbose -Message ($localizedData.RemoveFile -f $CsvPath)
    }
    catch 
    {
        Write-Error $error[0]
    }
}
