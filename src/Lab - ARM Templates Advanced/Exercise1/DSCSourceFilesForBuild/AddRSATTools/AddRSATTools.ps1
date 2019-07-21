Configuration AddRSATTools
{
  param(
      [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeploy DSC resources because the parameters have changed.')]
      [string]$Timestamp
      )

  Node localhost
  {
    #Install AD RSAT Tools
    WindowsFeature "AD-RSAT-Tools"
    {
      Ensure = "Present"
      Name = "RSAT-AD-Tools"
      IncludeAllSubFeature = $true
    }

    #Install DNS RSAT Tools
    WindowsFeature "DNS-RSAT-Tools"
    {
      Ensure = "Present"
      Name = "RSAT-DNS-Server"
    }

  }
}