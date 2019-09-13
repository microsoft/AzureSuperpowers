# AuditPolicyDsc

The **AuditPolicyDsc** module allows you to configure and manage the advanced audit policy on all
currently supported versions of Windows.

This project has adopted the [Microsoft Open Source Code of Conduct](
  https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](
  https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions
or comments.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/9nsi30ladk1jaax5/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/AuditPolicyDsc/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/9nsi30ladk1jaax5/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/AuditPolicyDsc/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resources [contributing guidelines](
  https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md).

## Resources

* [AuditPolicySubcategory](#AuditPolicySubcategory): Provides a mechanism to manage advanced auditpolicy subcategory audit flags.

* [AuditPolicyOption](#AuditPolicyOption): Provides a mechanism to manage audit policy options.

* [AuditPolicyCsv](#AuditPolicyCsv): Provides a mechanism to restore an audit policy backup from a CSV file.

* [AuditPolicyGUID](#AuditPolicyGuid): Provides a version of AuditPolicySubcategory that works around localization issues with auditpol.

### AuditPolicySubcategory

Provides a mechanism to manage advanced audit policy subcategory audit flags.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] Name _(Key)_**: The name of the subcategory in the advanced audit policy to manage.

* **[String] AuditFlag _(Key)_**: The name of the audit flag to apply to the subcategory. { Success | Failure }.

* **[String] Ensure _(Write)_**: Indicates whether the service is present or absent. Defaults to Present. { *Present* | Absent }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Set Audit Policy Subcategory Audit Flags](
  https://github.com/PowerShell/AuditPolicyDsc/blob/master/Examples/Sample_AuditPolicySubcategory.ps1)

### AuditPolicyOption

Provides a mechanism to manage audit policy options.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] Name _(Key)_**: The name of the option to configure.

* **[String] Value _(Key)_**: The value to apply to the option. { Enabled | Disabled }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Set Audit Policy Option](
  https://github.com/PowerShell/AuditPolicyDsc/blob/master/Examples/Sample_AuditPolicyOption.ps1)

### AuditPolicyCsv

Provides a mechanism to restore an audit policy backup.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] CsvPath _(Required)_**: The path to the CSV file to apply to the node.

* **[String] IsSingleInstance _(Key)_**: Specifies if the resource is a single instance, the value must be 'Yes'.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Apply audit policy backup from a CSV file](
  https://github.com/PowerShell/AuditPolicyDsc/blob/master/Examples/Sample_AuditPolicyCsv.ps1)

### AuditPolicyGuid

Provides a version of AuditPolicySubcategory that works around localization issues with auditpol.

#### Requirements

None

#### Parameters

* **[String] Name _(Key)_**: The name of the subcategory in the advanced audit policy to manage.

* **[String] AuditFlag _(Key)_**: The name of the audit flag to apply to the subcategory. { Success | Failure }.

* **[String] Ensure _(Write)_**: Indicates whether the service is present or absent. Defaults to Present. { *Present* | Absent }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Set Audit Policy Subcategory Audit Flags](
  https://github.com/PowerShell/AuditPolicyDsc/blob/master/Examples/Sample_AuditPolicyGuid.ps1)

## Versions

### Unreleased

### 1.4.0.0

* Explicitly removed extra hidden files from release package

### 1.3.0.0

* Update LICENSE file to match the Microsoft Open Source Team standard.
* Added the AuditPolicyGuid resource.

### 1.2.0.0

*  Moved auditpol call in the helper module to an external process to better control output
* auditpol output is now converted to CSV to remove the need to parse the text output
* All resources have been updated to use the new helper module functionality
* Added the Ensure parameter default value of Present to the AuditPolicySubcategory resource Test-TargetResource function

### 1.1.0.0

* Added the AuditPolicyCsv resource.

### 1.0.0.0

* Initial release with the following resources:

  * AuditPolicySubcategory
  * AuditPolicyOption
