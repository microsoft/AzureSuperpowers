Configuration AddIIS
{
  param(
      [Parameter(HelpMessage='Timestamp used solely as a mechanism to force ARM to redeply DSC resources because the parameters have changed.')]
      [string]$Timestamp
      )

  Node localhost
  {
    #Install the IIS Role
    WindowsFeature IIS
    {
      Ensure = “Present”
      Name = “Web-Server”
    }

    #Install ASP.NET 4.5
    WindowsFeature ASP
    {
      Ensure = “Present”
      Name = “Web-Asp-Net45”
    }

     WindowsFeature WebServerManagementConsole
    {
        Name = "Web-Mgmt-Console"
        Ensure = "Present"
    }
  }
} 