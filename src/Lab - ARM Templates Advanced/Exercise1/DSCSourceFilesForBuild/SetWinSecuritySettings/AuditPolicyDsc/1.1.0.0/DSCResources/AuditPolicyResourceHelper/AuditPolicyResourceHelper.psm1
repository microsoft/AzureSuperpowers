#Requires -Version 4.0

<# 
    This PS module contains functions for Desired State Configuration (DSC) AuditPolicyDsc provider. 
    It enables querying, creation, removal and update of Windows advanced audit policies through 
    Get, Set, and Test operations on DSC managed nodes.
#>

<#
    .SYNOPSIS
        Retrieves the localized string data based on the machine's culture.
        Falls back to en-US strings if the machine's culture is not supported.

    .PARAMETER ResourceName
        The name of the resource as it appears before '.strings.psd1' of the localized string file.
        For example:
            AuditPolicySubcategory: MSFT_AuditPolicySubcategory
            AuditPolicyOption: MSFT_AuditPolicyOption
#>
function Get-LocalizedData
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'resource')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ResourceName,

        [Parameter(Mandatory = $true, ParameterSetName = 'helper')]
        [ValidateNotNullOrEmpty()]
        [String]
        $HelperName
    )

    # With the helper module just update the name and path variables as if it were a resource. 
    if ($PSCmdlet.ParameterSetName -eq 'helper')
    {
        $resourceDirectory = $PSScriptRoot
        $ResourceName = $HelperName
    }
    else 
    {
        # Step up one additional level to build the correct path to the resource culture.
        $resourceDirectory = Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
                                       -ChildPath $ResourceName
    }

    $localizedStringFileLocation = Join-Path -Path $resourceDirectory -ChildPath $PSUICulture

    if (-not (Test-Path -Path $localizedStringFileLocation))
    {
        # Fallback to en-US
        $localizedStringFileLocation = Join-Path -Path $resourceDirectory -ChildPath 'en-US'
    }

    Import-LocalizedData `
        -BindingVariable 'localizedData' `
        -FileName "$ResourceName.strings.psd1" `
        -BaseDirectory $localizedStringFileLocation

    return $localizedData
}

<#
 .SYNOPSIS
    Invoke-AuditPol is a private function that wraps auditpol.exe providing a 
    centralized function to manage access to and the output of auditpol.exe.    
 .DESCRIPTION
    The function will accept a string to pass to auditpol.exe for execution. Any 'get' or
    'set' opertions can be passed to the central wrapper to execute. All of the 
    nuances of auditpol.exe can be further broken out into specalized functions that 
    call Invoke-AuditPol.   
    
    Since the call operator is being used to run auditpol, the input is restricted to only execute
    against auditpol.exe. Any input that is an invalid flag or parameter in 
    auditpol.exe will return an error to prevent abuse of the call.
    The call operator will not parse the parameters, so they are split in the function. 
 .PARAMETER Command 
    The action that audtipol should take on the subcommand.
 .PARAMETER SubCommand 
    The subcommand to execute.
 .OUTPUTS
    The raw string output of auditpol.exe with the /r switch to return a CSV string. 
 .EXAMPLE
    Invoke-AuditPol -Command 'Get' -SubCommand 'Subcategory:Logon'
#>
function Invoke-AuditPol
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Set', 'List','Restore','Backup')]
        [System.String]
        $Command,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $SubCommand
    )

    # Localized messages for Write-Verbose statements in this resource
    $localizedData = Get-LocalizedData -HelperName 'AuditPolicyResourceHelper'
    <# 
        The raw auditpol data with the /r switch is a 3 line CSV
        0 - header row
        1 - blank row
        2 - the data row we are interested in
    #>

    # set the base commands to execute
    if ( $Command -eq 'Get') 
    { 
        $commandString = @("/$Command","/$SubCommand","/r" )
    }
    else
    {
        # The set subcommand comes in an array of the subcategory and flag 
        $commandString = @("/$Command","/$($SubCommand[0])",$SubCommand[1] )
    }

    Write-Debug -Message ( $localizedData.ExecuteAuditpolCommand -f $commandString )

    try
    {
        # Use the call operator to process the auditpol command
        $auditPolicyCommandResult = & "auditpol.exe" $commandString 2>&1

        # auditpol does not throw exceptions, so test the results and throw if needed
        if ( $LASTEXITCODE -ne 0 )
        {
            throw New-Object System.ArgumentException
        }

        if ($Command -notmatch "Restore|Backup")
        {
            return $auditPolicyCommandResult
        }       
    }
    catch [System.Management.Automation.CommandNotFoundException]
    {
        # Catch error if the auditpol command is not found on the system
        Write-Error -Message $localizedData.AuditpolNotFound
    }
    catch [System.ArgumentException]
    {
        # Catch the error thrown if the lastexitcode is not 0 
        [String] $errorString = $error[0].Exception
        $errorString = $errorString + "`$LASTEXITCODE = $LASTEXITCODE;"
        $errorString = $errorString + " Command = auditpol $commandString"
        
        Write-Error -Message $errorString
    }
    catch
    {
        # Catch any other errors
        Write-Error -Message ( $localizedData.UnknownError -f $error[0] )
    }
}

<#
    .SYNOPSIS
        Returns the list of valid Subcategories.
    .DESCRIPTION
        This funciton will check if the list of valid subcategories has already been created. 
        If the list exists it will simply return it. If it doe not exists, it will generate 
        it and return it.  
#>
function Get-ValidSubcategoryList
{
    [OutputType([String[]])]
    [CmdletBinding()]
    param ()

    if ($null -eq $script:validSubcategoryList)
    {
        $script:validSubcategoryList = @()

        # Populating $validSubcategoryList uses Invoke-AuditPol and needs to follow the definition.
        Invoke-AuditPol -Command List -SubCommand "Subcategory:*" | 
            Where-Object { $_ -notlike 'Category/Subcategory*' } | 
                ForEach-Object {
            # The categories do not have any space in front of them, but the subcategories do.
            if ( $_ -like " *" )
            {
                $script:validSubcategoryList += $_.trim()
            }
        } 
    }

    return $script:validSubcategoryList
}

<#
    .SYNOPSIS
        Verifies that the Subcategory is valid.
    .PARAMETER Name
        The name of the Subcategory to validate.
#>
function Test-ValidSubcategory
{
    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name
    )

    if ( ( Get-ValidSubcategoryList ) -icontains $Name )
    {
        return $true
    }
    else 
    {
        return $false    
    }
}

Export-ModuleMember -Function @( 'Invoke-AuditPol', 'Get-LocalizedData', 
    'Test-ValidSubcategory' )
