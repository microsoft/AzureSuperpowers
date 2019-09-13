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
function Get-LocalizedData {
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
    if ($PSCmdlet.ParameterSetName -eq 'helper') {
        $resourceDirectory = $PSScriptRoot
        $ResourceName = $HelperName
    }
    else {
        # Step up one additional level to build the correct path to the resource culture.
        $resourceDirectory = Join-Path -Path ( Split-Path $PSScriptRoot -Parent ) `
            -ChildPath $ResourceName
    }

    $localizedStringFileLocation = Join-Path -Path $resourceDirectory -ChildPath $PSUICulture

    if (-not (Test-Path -Path $localizedStringFileLocation)) {
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
function Invoke-AuditPol {
    [OutputType([Object])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Set', 'List', 'Restore', 'Backup')]
        [String]
        $Command,

        [Parameter(Mandatory = $true)]
        [String[]]
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
    if ( $Command -eq 'Get') {
        $auditpolArguments = @("/$Command", "/$SubCommand", "/r" )
    }
    else {
        # The set subcommand comes in an array of the subcategory and flag
        $auditpolArguments = @("/$Command", "/$($SubCommand[0])", $SubCommand[1] )
    }

    Write-Debug -Message ( $localizedData.ExecuteAuditpolCommand -f $auditpolArguments )

    try {
        # Use System.Diagnostics.Process to process the auditpol command
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo.Arguments = $auditpolArguments
        $process.StartInfo.CreateNoWindow = $true
        $process.StartInfo.FileName = 'auditpol.exe'
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.UseShellExecute = $false
        $null = $process.Start()

        $auditpolReturn = $process.StandardOutput.ReadToEnd()

        # auditpol does not throw exceptions, so test the results and throw if needed
        if ( $process.ExitCode -ne 0 ) {
            throw New-Object System.ArgumentException
        }

        if ( $Command -notmatch "Restore|Backup" ) {
            return ( ConvertFrom-Csv -InputObject $auditpolReturn )
        }
    }
    catch [System.ComponentModel.Win32Exception] {
        # Catch error if the auditpol command is not found on the system
        Write-Error -Message $localizedData.AuditpolNotFound
    }
    catch [System.ArgumentException] {
        # Catch the error thrown if the lastexitcode is not 0
        [String] $errorString = $error[0].Exception
        $errorString = $errorString + "`$LASTEXITCODE = $LASTEXITCODE;"
        $errorString = $errorString + " Command = auditpol $commandString"
        Write-Error -Message $errorString
    }
    catch {
        # Catch any other errors
        Write-Error -Message ( $localizedData.UnknownError -f $error[0] )
    }
}

<#
 .SYNOPSIS
    Get-FixedLanguageAuditCSV is a private function that returns the contents of a CSV with US-English names, even if input is not US English
 .PARAMETER Path
    The path to stage the auditCSV to (defaulted to the temp directory).
    FILE MUST EXIST AND BE A VALID AUDIT.CSV FILE, AND THE FIRST LINE MUST BE THE CSV HEADER.
 .OUTPUTS
    Content from the file converted from CSV to custom objects with US-English property names.
 .EXAMPLE
    $csv = Get-StagedAuditPolicy
#>
function Get-FixedLanguageAuditCSV {
    [OutputType([System.Object[]])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [String]
        $Path = $(Join-Path -Path $env:Temp -ChildPath "audit.csv")
    )

    $headerSet =
    "Machine Name",
    "Policy Target",
    "Subcategory",
    "Subcategory GUID",
    "Inclusion Setting",
    "Exclusion Setting",
    "Setting Value"

    return (Get-Content -Path $Path | Select-Object -Skip 1 | ConvertFrom-Csv -Header $headerSet)
}

<#
 .SYNOPSIS
    Get-StagedAuditPol is a private function that creates staged AuditPolicy CSVs for usage over several resource blocks
 .DESCRIPTION
    The function tests if a staged AuditPolicyCSV is available and not out of date.  If needed, it creates a new staged CSV
 .PARAMETER Path
    The path to stage the auditCSV to (defaulted to the temp directory)
 .OUTPUTS
    The current or newly created Staged CSV.
 .EXAMPLE
    $csv = Get-StagedAuditPolicy
#>
function Get-StagedAuditPolicyCSV {
    [OutputType([System.Object[]])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [String]
        $Path = $(Join-Path -Path $env:Temp -ChildPath "audit.csv")
    )

    # Localized messages for Write-Verbose statements in this resource
    $localizedData = Get-LocalizedData -HelperName 'AuditPolicyResourceHelper'

    $auditCSV = Get-Item -Path $Path -ErrorAction SilentlyContinue
    if ($null -ne $auditCSV) {
        # Determine if the CSV was created more than 5 minutes ago, if it was, delete it and create a new one.
        if ((New-TimeSpan -Start $auditCSV.CreationTime -End ([datetime]::Now)).Minutes -ge 5) {
            Write-Debug -Message ( $localizedData.AuditCSVOutdated -f $path, $auditCSV.CreationTime)
            Try {
                Remove-Item -Path $auditCSV -Force
                Write-Debug -Message ( $localizedData.AuditCSVDeleted -f $Path)
            }
            Catch {
                Write-Debug -Message ( $localizedData.AuditCSVLocked -f $Path)
                Continue
            }
        }
        else {
            Write-Debug -Message ( $localizedData.AuditCSVLocked -f $Path)
            return Get-FixedLanguageAuditCSV -Path $auditCSV
        }
    }

    Write-Debug -Message ( $localizedData.AuditCSVNotFound -f $Path)
    Invoke-AuditPol -Command "Backup" -SubCommand "file:$Path"
    Write-Debug -Message ( $localizedData.AuditCSVCreated -f $auditCSV )
    if (!(Test-Path -Path $Path)) {
        $inf = [System.Management.Automation.ItemNotFoundException]::new( ($localizedData.FileNotFound -f $Path), $fnf)
        Throw $inf
    }
    $auditCSV = Get-Item -Path $Path

    return Get-FixedLanguageAuditCSV $auditCSV
}

# Static Name translation to ensure GUIDS are the source of truth.
### Hash table to map audit subcategory names (US English) to GUIDs
$AuditSubcategoryToGUIDHash = @{
    ###### Edited from "auditpol /list /subcategory:* /v"
    ######
    ######Category/Subcategory                  GUID
    ######System                                = "69979848-797A-11D9-BED3-505054503030";
    "Security State Change"                  = "0CCE9210-69AE-11D9-BED3-505054503030";
    "Security System Extension"              = "0CCE9211-69AE-11D9-BED3-505054503030";
    "System Integrity"                       = "0CCE9212-69AE-11D9-BED3-505054503030";
    "IPsec Driver"                           = "0CCE9213-69AE-11D9-BED3-505054503030";
    "Other System Events"                    = "0CCE9214-69AE-11D9-BED3-505054503030";
    ######Logon/Logoff                          = "69979849-797A-11D9-BED3-505054503030";
    "Logon"                                  = "0CCE9215-69AE-11D9-BED3-505054503030";
    "Logoff"                                 = "0CCE9216-69AE-11D9-BED3-505054503030";
    "Account Lockout"                        = "0CCE9217-69AE-11D9-BED3-505054503030";
    "IPsec Main Mode"                        = "0CCE9218-69AE-11D9-BED3-505054503030";
    "IPsec Quick Mode"                       = "0CCE9219-69AE-11D9-BED3-505054503030";
    "IPsec Extended Mode"                    = "0CCE921A-69AE-11D9-BED3-505054503030";
    "Special Logon"                          = "0CCE921B-69AE-11D9-BED3-505054503030";
    "Other Logon/Logoff Events"              = "0CCE921C-69AE-11D9-BED3-505054503030";
    "Network Policy Server"                  = "0CCE9243-69AE-11D9-BED3-505054503030";
    "User / Device Claims"                   = "0CCE9247-69AE-11D9-BED3-505054503030";
    "Group Membership"                       = "0CCE9249-69AE-11D9-BED3-505054503030";
    ######Object Access                         = "6997984A-797A-11D9-BED3-505054503030";
    "File System"                            = "0CCE921D-69AE-11D9-BED3-505054503030";
    "Registry"                               = "0CCE921E-69AE-11D9-BED3-505054503030";
    "Kernel Object"                          = "0CCE921F-69AE-11D9-BED3-505054503030";
    "SAM"                                    = "0CCE9220-69AE-11D9-BED3-505054503030";
    "Certification Services"                 = "0CCE9221-69AE-11D9-BED3-505054503030";
    "Application Generated"                  = "0CCE9222-69AE-11D9-BED3-505054503030";
    "Handle Manipulation"                    = "0CCE9223-69AE-11D9-BED3-505054503030";
    "File Share"                             = "0CCE9224-69AE-11D9-BED3-505054503030";
    "Filtering Platform Packet Drop"         = "0CCE9225-69AE-11D9-BED3-505054503030";
    "Filtering Platform Connection"          = "0CCE9226-69AE-11D9-BED3-505054503030";
    "Other Object Access Events"             = "0CCE9227-69AE-11D9-BED3-505054503030";
    "Detailed File Share"                    = "0CCE9244-69AE-11D9-BED3-505054503030";
    "Removable Storage"                      = "0CCE9245-69AE-11D9-BED3-505054503030";
    "Central Policy Staging"                 = "0CCE9246-69AE-11D9-BED3-505054503030";
    ######Privilege Use                         = "6997984B-797A-11D9-BED3-505054503030";
    "Sensitive Privilege Use"                = "0CCE9228-69AE-11D9-BED3-505054503030";
    "Non Sensitive Privilege Use"            = "0CCE9229-69AE-11D9-BED3-505054503030";
    "Other Privilege Use Events"             = "0CCE922A-69AE-11D9-BED3-505054503030";
    ######Detailed Tracking                     = "6997984C-797A-11D9-BED3-505054503030";
    "Process Creation"                       = "0CCE922B-69AE-11D9-BED3-505054503030";
    "Process Termination"                    = "0CCE922C-69AE-11D9-BED3-505054503030";
    "DPAPI Activity"                         = "0CCE922D-69AE-11D9-BED3-505054503030";
    "RPC Events"                             = "0CCE922E-69AE-11D9-BED3-505054503030";
    "Plug and Play Events"                   = "0CCE9248-69AE-11D9-BED3-505054503030";
    "Token Right Adjusted Events"            = "0CCE924A-69AE-11D9-BED3-505054503030";
    ######Policy Change                         = "6997984D-797A-11D9-BED3-505054503030";
    "Audit Policy Change"                    = "0CCE922F-69AE-11D9-BED3-505054503030";
    "Authentication Policy Change"           = "0CCE9230-69AE-11D9-BED3-505054503030";
    "Authorization Policy Change"            = "0CCE9231-69AE-11D9-BED3-505054503030";
    "MPSSVC Rule-Level Policy Change"        = "0CCE9232-69AE-11D9-BED3-505054503030";
    "Filtering Platform Policy Change"       = "0CCE9233-69AE-11D9-BED3-505054503030";
    "Other Policy Change Events"             = "0CCE9234-69AE-11D9-BED3-505054503030";
    ######Account Management                    = "6997984E-797A-11D9-BED3-505054503030";
    "User Account Management"                = "0CCE9235-69AE-11D9-BED3-505054503030";
    "Computer Account Management"            = "0CCE9236-69AE-11D9-BED3-505054503030";
    "Security Group Management"              = "0CCE9237-69AE-11D9-BED3-505054503030";
    "Distribution Group Management"          = "0CCE9238-69AE-11D9-BED3-505054503030";
    "Application Group Management"           = "0CCE9239-69AE-11D9-BED3-505054503030";
    "Other Account Management Events"        = "0CCE923A-69AE-11D9-BED3-505054503030";
    ######DS Access                             = "6997984F-797A-11D9-BED3-505054503030";
    "Directory Service Access"               = "0CCE923B-69AE-11D9-BED3-505054503030";
    "Directory Service Changes"              = "0CCE923C-69AE-11D9-BED3-505054503030";
    "Directory Service Replication"          = "0CCE923D-69AE-11D9-BED3-505054503030";
    "Detailed Directory Service Replication" = "0CCE923E-69AE-11D9-BED3-505054503030";
    ######Account Logon                         = "69979850-797A-11D9-BED3-505054503030";
    "Credential Validation"                  = "0CCE923F-69AE-11D9-BED3-505054503030";
    "Kerberos Service Ticket Operations"     = "0CCE9240-69AE-11D9-BED3-505054503030";
    "Other Account Logon Events"             = "0CCE9241-69AE-11D9-BED3-505054503030";
    "Kerberos Authentication Service"        = "0CCE9242-69AE-11D9-BED3-505054503030";
}

### Hash table to map GUIDs to audit subcategory names (US English)
$AuditGUIDToSubCategoryHash = @{}
$AuditSubcategoryToGUIDHash.Keys | ForEach-Object {
    $AuditGUIDToSubCategoryHash.Add($AuditSubcategoryToGUIDHash[$_], $_)
}


$AuditFlagToSettingValue = @{
    'No Auditing'         = 0
    'Success'             = 1
    'Failure'             = 2
    'Success and Failure' = 3
}

$AuditSettingValueToFlag = @(
    'No Auditing',
    'Success',
    'Failure',
    'Success and Failure'
)

<#
 .SYNOPSIS
    Write-StagedAuditCSV is a private function that writes new values to the Staged Audit.CSV and imports them using auditpol
 .DESCRIPTION
    The function takes a new value to write and combines it with the staged csv.
 .PARAMETER Name
    The subcategory.
 .PARAMETER Flag
    The flag the subcategory should be set to.
 .PARAMETER Path
    The path to stage the auditCSV to (defaulted to the temp directory)
 .OUTPUTS
    The current or newly created Staged CSV.
 .EXAMPLE
    Write-StagedAuditCSV -Name
#>
function Write-StagedAuditCSV {
    [OutputType([System.Object[]])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [GUID]
        $GUID,

        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 4)]
        [Int]
        $SettingValue,

        [Parameter()]
        [String]
        $Path = $(Join-Path -Path $env:Temp -ChildPath "audit.csv"),

        [Parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [String]
        $Ensure
    )

    if ($AuditGUIDToSubCategoryHash.ContainsKey($GUID.Guid)) {
        $Name = $AuditGUIDToSubCategoryHash[$GUID.Guid]
    }
    else {
        Throw ($localizedData.SubCategoryTranslationFailed -f $GUID)
    }

    # translate Present/Absent to inclusion settings
    $auditState = [pscustomobject]@{
        'Inclusion Setting' = ''
        'Exclusion Setting' = ''
    }

    $auditFlag = $AuditSettingValueToFlag[$SettingValue]

    # Localized messages for Write-Verbose statements in this resource
    $localizedData = Get-LocalizedData -HelperName 'AuditPolicyResourceHelper'

    $auditCSV = Get-StagedAuditPolicyCSV

    $currentValue = $auditCSV.Where( {$_.'SubCategory GUID' -eq "{$($GUID.guid)}"})
    $currentSetting = 0
    if ($null -eq $currentValue) {
        Write-Debug -Message ($localizedData.CurrentCSVValueMissing -f $GUID)
        $currentSetting = 0
    }
    else {
        $currentSetting = $currentValue.'Setting Value'
    }

    if ($Ensure -eq "Present") {
        $auditState.'Inclusion Setting' = $auditFlag
    }
    else {
        switch ($currentSetting) {
            0 {
                # There's no way to set the Absent of No Auditing.
                # Should it be Success? Failure? Both?
                return
            }

            1 {
                if ($currentSetting -eq 1) {
                    # If Success is absent and the current value is Success, the result is "No Auditing"
                    $SettingValue = 0
                }
                elseif ($currentSetting -eq 3) {
                    # If Success is absent and the current value is Succes and Failure, the result is Failure.
                    $SettingValue = 2
                }
                else {
                    $SettingValue = $currentSetting
                }
            }

            2 {
                if ($currentSetting -eq 2) {
                    # If Failure is absent and the current value is Failure, the result is "No Auditing"
                    $SettingValue = 0
                }
                elseif ($currentSetting -eq 3) {
                    # If Success is absent and the current value is Succes and Failure, the result is Success.
                    $SettingValue = 1
                }
                else {
                    $SettingValue = $currentSetting
                }
            }

            3 {
                # if Success And Failure should be absent, the result is No Auditing
                $SettingValue = 0
            }
        }

        $auditState.'Exclusion Setting' = $auditFlag
    }

    $auditCSV = $auditCSV | Where-Object {$_.'Subcategory GUID' -ne "{$($GUID.guid)}" -and !([string]::IsNullOrEmpty($_.'Subcategory GUID'))}
    $tmpValue = [pscustomobject][ordered]@{
        'Machine Name'      = $env:ComputerName
        'Policy Target'     = "System"
        'Subcategory'       = "Audit $Name"
        'SubCategory GUID'  = "{$($GUID.guid)}"
        'Inclusion Setting' = $auditState.'Inclusion Setting'
        'ExclusionSetting'  = $auditState.'Exclusion Setting'
        'Setting Value'     = $SettingValue
    }

    $auditCSV += $tmpValue

    Write-Debug -Message ( $localizedData.WriteStagedCSV -f $Guid, $AuditFlag )

    Try {
        $auditCSV | ConvertTo-Csv -NoTypeInformation | ForEach-Object {$_.Replace('"', '')} | Out-File -FilePath $Path -Force
    }
    Catch {
        Throw ($localizedata.SaveAuditCSVFailure -f $Path)
    }

    Invoke-AuditPol -Command Restore -SubCommand "file:$Path"
    Write-Debug -Message ( $localizedData.RestoredAuditCSV )
}

<#
    .SYNOPSIS
        Returns the list of valid Subcategories.
    .DESCRIPTION
        This funciton will check if the list of valid subcategories has already been created.
        If the list exists it will simply return it. If it doe not exists, it will generate
        it and return it.
#>
function Get-ValidSubcategoryList {
    [OutputType([String[]])]
    [CmdletBinding()]
    param ()

    if ( $null -eq $script:validSubcategoryList ) {
        $script:validSubcategoryList = @()

        # Populating $validSubcategoryList uses Invoke-AuditPol and needs to follow the definition.
        # Populating $validSubcategoryList uses Invoke-AuditPol and needs to follow the definition.
        $script:validSubcategoryList = Invoke-AuditPol -Command Get -SubCommand "category:*" |
            Select-Object -Property Subcategory -ExpandProperty Subcategory
    }

    return $script:validSubcategoryList
}

<#
    .SYNOPSIS
        Verifies that the Subcategory is valid.
    .PARAMETER Name
        The name of the Subcategory to validate.
#>
function Test-ValidSubcategory {
    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name
    )

    if ( ( Get-ValidSubcategoryList ) -icontains $Name ) {
        return $true
    }
    else {
        return $false
    }
}

Export-ModuleMember -Variable AuditSubCategorytoGUIDHash, AuditGUIDTOSubCategoryHash, AuditFlagToSettingValue, AuditSettingValueToFlag -Function @( 'Invoke-AuditPol', 'Get-LocalizedData', 'Write-StagedAuditCSV', 'Get-StagedAuditPolicyCSV', 'Get-FixedLanguageAuditCSV',
    'Test-ValidSubcategory' )
