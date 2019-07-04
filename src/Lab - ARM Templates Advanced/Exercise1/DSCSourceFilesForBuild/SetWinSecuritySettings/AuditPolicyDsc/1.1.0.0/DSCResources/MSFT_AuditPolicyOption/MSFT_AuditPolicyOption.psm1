
Import-Module -Name (Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
                               -ChildPath 'AuditPolicyResourceHelper\AuditPolicyResourceHelper.psm1') `
                               -Force

# Localized messages for Write-Verbose statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_AuditPolicyOption'

<#
    .SYNOPSIS
        Gets the value of the audit policy option.
    .PARAMETER Name
        Specifies the option to get.
    .PARAMETER Value
        Not used in Get-TargetResource.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('CrashOnAuditFail', 'FullPrivilegeAuditing', 'AuditBaseObjects',
        'AuditBaseDirectories')]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $Value
    )
    
    # Get the option's current value 
    $optionValue = Get-AuditOption -Name $Name

    Write-Verbose -Message ( $localizedData.GetAuditpolOptionSucceed -f $Name )

    return @{
        Name   = $Name
        Value  = $optionValue
    }
}

<#
    .SYNOPSIS
        Sets the value of the audit policy option.
    .PARAMETER Name
        Specifies the option to set.
    .PARAMETER Value
        Specifies the value to set the option to.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('CrashOnAuditFail', 'FullPrivilegeAuditing', 'AuditBaseObjects',
        'AuditBaseDirectories')]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $Value
    )

    try 
    {
        Set-AuditOption -Name $Name -Value $Value
        Write-Verbose -Message ( $localizedData.SetAuditpolOptionSucceed -f $Name, $Value )
    }
    catch
    {
        Write-Verbose -Message ( $localizedData.SetAuditpolOptionFailed -f $Name, $Value )
    }
}

<#
    .SYNOPSIS
        Tests that the audit policy option is in the desired state 
    .PARAMETER Name
        Specifies the option to test.
    .PARAMETER Value
        Specifies the value to test against the option.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('CrashOnAuditFail', 'FullPrivilegeAuditing', 'AuditBaseObjects',
        'AuditBaseDirectories')]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $Value
    )

    if ( ( Get-AuditOption -Name $Name ) -eq $Value )
    {
        Write-Verbose -Message ( $localizedData.TestAuditpolOptionCorrect -f $Name, $value )
        return $true
    }
    else
    {
        Write-Verbose -Message ( $localizedData.TestAuditpolOptionIncorrect -f $Name, $value )
        return $false
    }
}

#---------------------------------------------------------------------------------------------------
# Support functions to handle auditpol I/O

<#
    .SYNOPSIS
        Gets the audit policy option state.
    .DESCRIPTION
        Ths is one of the public functions that calls into Get-AuditOptionCommand.
        This function enforces parameters that will be passed through to the 
        Get-AuditOptionCommand function and aligns to a specifc parameterset. 
    .PARAMETER Option 
        The name of an audit option.
    .OUTPUTS
        A string that is the state of the option (Enabled|Disables). 
#>
function Get-AuditOption
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        $Name
    )
    <#
        When PowerShell cmdlets are released for individual audit policy settings a condition 
        will be placed here to use native PowerShell cmdlets to set the option details. 
    #>
    # get the auditpol raw csv output
    $returnCsv =  Invoke-AuditPol -Command "Get" -SubCommand "Option:$Name"
    
    # split the details into an array
    $optionDetails = ( $returnCsv[2] ) -Split ','

    # return the option value
    return $optionDetails[4]
}

<#
    .SYNOPSIS
        Sets an audit policy option to enabled or disabled.
    .DESCRIPTION
        This public function calls Set-AuditOptionCommand and enforces parameters 
        that will be passed to Set-AuditOptionCommand and aligns to a specifc parameterset. 
    .PARAMETER Name
        The specific option to set.
    .PARAMETER Value 
        The value to set the provided option to.
#>
function Set-AuditOption
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        $Name,
        
        [Parameter(Mandatory=$true)]
        [System.String]
        $Value
    )

    <#
        When PowerShell cmdlets are released for individual audit policy settings a condition 
        will be placed here to use native PowerShell cmdlets to set the option details. 
    #>
    if ( $pscmdlet.ShouldProcess( "$Name","Set $Value" ) ) 
    {
        <# 
            The output text of auditpol is in simple past tense, but the input is in simple 
            present tense, so the hashtable converts the input accordingly.
        #>
        $pastToPresentValues = @{
            'Enabled'  = 'enable'
            'Disabled' = 'disable'
        }
        
        [String[]] $subCommand = @( "Option:$Name", "/value:$($pastToPresentValues[$value])" )

        Invoke-AuditPol -Command 'Set' -SubCommand $subCommand | Out-Null
    }
}

Export-ModuleMember -Function *-TargetResource
