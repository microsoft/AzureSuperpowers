
Import-Module -Name (Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
                               -ChildPath 'AuditPolicyResourceHelper\AuditPolicyResourceHelper.psm1') `
                               -Force

# Localized messages for Write-Verbose statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_AuditPolicyGUID'

<#
    .SYNOPSIS
        Returns the current audit flag for the given subcategory.
    .PARAMETER Name
        Specifies the subcategory to retrieve.
    .PARAMETER AuditFlag
        Specifies the audit flag to retrieve.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Success', 'Failure', 'No Auditing', 'Success And Failure')]
        [String]
        $AuditFlag
    )

    # Work in GUIDS and Setting Values the rest of the way
    $GUID = Get-AuditSubCategoryGuid -Name $Name
    $SettingValue = $AuditFlagToSettingValue[$AuditFlag]

    try
    {
        $currentAuditSetting = Get-AuditSubCategory -GUID $GUID
        Write-Verbose -Message ( $localizedData.GetAuditpolSubcategorySucceed -f $Name, $AuditFlag )
    }
    catch
    {
        Write-Verbose -Message ( $localizedData.GetAuditPolSubcategoryFailed -f $Name, $AuditFlag )
    }

    <#
        The auditType property returned from Get-AuditSubCategory can be 'None','Success',
        'Failure', or 'Success and Failure'. Using the match operator will return the correct
        state if both are set.
    #>
    $currentAuditFlag = $AuditSettingValueToFlag[$currentAuditSetting]
    if ( $currentAuditSetting -eq $SettingValue )
    {
        $ensure = 'Present'
    }
    else
    {
        $ensure = 'Absent'
    }

    return @{
        Name      = $Name
        AuditFlag = $currentAuditFlag
        Ensure    = $ensure
    }
}

<#
    .SYNOPSIS
        Sets the audit flag for the given subcategory.
    .PARAMETER Name
        Specifies the subcategory to set.
    .PARAMETER AuditFlag
        Specifies the audit flag to set.
    .PARAMETER Ensure
        Specifies the state of the audit flag provided. By default this is set to Present.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Success', 'Failure', 'No Auditing', 'Success And Failure')]
        [String]
        $AuditFlag,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    # Work in GUIDS and Setting Values the rest of the way
    $GUID = Get-AuditSubCategoryGuid -Name $Name
    $SettingValue = $AuditFlagToSettingValue[$AuditFlag]

    try
    {
        Set-AuditSubcategory -GUID $GUID -SettingValue $SettingValue -Ensure $Ensure
        Write-Verbose -Message ( $localizedData.SetAuditpolSubcategorySucceed `
                        -f $Name, $AuditFlag, $Ensure )
    }
    catch
    {
        Write-Verbose -Message ( $localizedData.SetAuditpolSubcategoryFailed `
                        -f $Name, $AuditFlag, $Ensure )
    }
}

<#
    .SYNOPSIS
        Tests the audit flag state for the given subcategory.
    .PARAMETER Name
        Specifies the subcategory to test.
    .PARAMETER AuditFlag
        Specifies the audit flag to test.
    .PARAMETER Ensure
        Specifies the state of the audit flag should be in.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Success', 'Failure', 'No Auditing', 'Success And Failure')]
        [String]
        $AuditFlag,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure="Present"
    )

    [System.Boolean] $isInDesiredState = $false

    # Work in GUIDS and Setting Values the rest of the way
    $GUID = Get-AuditSubCategoryGuid -Name $Name
    [int]$SettingValue = $AuditFlagToSettingValue[$AuditFlag]

    try
    {
        [int]$currentAuditSetting = Get-AuditSubCategory -GUID $GUID
        Write-Verbose -Message ( $localizedData.GetAuditpolSubcategorySucceed -f $Name, $AuditFlag )
    }
    catch
    {
        Write-Verbose -Message ( $localizedData.GetAuditPolSubcategoryFailed -f $Name, $AuditFlag )
    }

    # If the setting should be present look for a match, otherwise look for a notmatch
    if ( $Ensure -eq 'Present' )
    {
        $isInDesiredState = $currentAuditSetting -eq $SettingValue
    }
    else
    {
        $isInDesiredState = $currentAuditSetting -ne $SettingValue
    }

    <#
        The audit type can be true in either a match or non-match state. If the audit type
        matches the ensure property return the setting correct message, else return the
        setting incorrect message
    #>
    if ( $isInDesiredState )
    {
        # TODO: Change back to normal
        Write-Verbose -Message ( $localizedData.TestAuditpolSubcategoryCorrect `
                        -f $Name, $AuditFlag, $Ensure )
        Write-Verbose $Ensure
    }
    else
    {
        Write-Verbose -Message ( $localizedData.TestAuditpolSubcategoryIncorrect `
                       -f $Name, $AuditFlag, $Ensure )
    }

    $isInDesiredState
}

#---------------------------------------------------------------------------------------------------
# Support functions to handle auditpol I/O

<#
    .SYNOPSIS
        Gets the audit flag state for a specifc subcategory.
    .DESCRIPTION
        This function enforces parameters that will be passed to Invoke-Auditpol.
    .PARAMETER GUID
        The GUID of the subcategory to get the audit flags from.
    .OUTPUTS
        A string with the flags that are set for the specificed subcategory
    .EXAMPLE
        Get-AuditSubCategory -Name 'Logon'
#>
function Get-AuditSubCategory
{
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param
    (
        [Parameter(Mandatory = $true)]
        [GUID]
        $GUID
    )
    <#
        When PowerShell cmdlets are released for individual audit policy settings a condition
        will be placed here to use native PowerShell cmdlets to set the option details.
    #>
    # get the auditpol raw csv output
    $returnCsv = Get-StagedAuditPolicyCSV | Where-Object {$_.'SubCategory GUID' -eq "{$($GUID.guid)}"}

    if ($returnCsv)
    {
        return $returnCsv.'Setting Value'
    }
    else
    {
        Throw ($localizedData.RetrieveSettingFailure -f $GUID)
    }
}

<#
    .SYNOPSIS
        Sets the audit flag state for a specifc subcategory.
    .DESCRIPTION
        Calls the private function to execute a set operation on the given subcategory
    .PARAMETER GUID
        The GUID of the audit subcategory to set
    .PARAMETER SettingValue
        The Flag to set as an integer
    .PARAMETER Ensure
        The action to take on the flag
    .EXAMPLE
        Set-AuditSubcategory -GUID {0CCE923A-69AE-11D9-BED3-505054503030} -SettingValue 3 -Ensure 'Present'
#>
function Set-AuditSubcategory
{
    [CmdletBinding()]
    param
    (
        [Parameter( Mandatory = $true )]
        [GUID]
        $GUID,

        [Parameter( Mandatory = $true )]
        [ValidateRange(0, 3)]
        [Int]
        $SettingValue,

        [Parameter( Mandatory = $true )]
        [String]
        $Ensure
    )

    <#
        When PowerShell cmdlets are released for individual audit policy settings a condition
        will be placed here to use native PowerShell cmdlets to set the option details.
    #>

    Write-StagedAuditCSV -Guid $GUID -SettingValue $SettingValue -Ensure $Ensure
}

<#
    .SYNOPSIS
        Gets the guild for a specified subcategory
    .DESCRIPTION
        Uses an imported hashtable of static values
    .PARAMETER Name
        The Subcategory to retrieve the GUID for.
    .EXAMPLE
        Get-AuditSubCategoryGUID -Name 'Process Creation'
#>
Function Get-AuditSubCategoryGuid
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Name
    )

    if ($AuditSubCategoryToGUIDHash.ContainsKey($Name))
    {
        $GUID = $AuditSubCategorytoGUIDHash[$Name]
        Write-Verbose -Message ( $localizedData.AuditSubCategoryGUIDFound -f $Name, $GUID )
        return $GUID
    }
    else
    {
        Throw ( $localizedData.AuditSubCategoryGUIDNotFound -f $Name )
    }
}

Export-ModuleMember -Function *-TargetResource
