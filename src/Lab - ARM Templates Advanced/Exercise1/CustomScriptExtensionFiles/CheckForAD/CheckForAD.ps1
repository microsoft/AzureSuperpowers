do
{
$sysvolonline = Test-Path C:\Windows\SYSVOL\domain\Policies
if ($sysvolonline -ne $true)
{
    Write-Output 'SYSVOL is not online yet, attempting again in 5 seconds'
}
Start-Sleep -Seconds 5
}
until ($sysvolonline -eq $true)