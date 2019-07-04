###
# The intention is to go through all Resource Templates and find the DSC resource it is referencing
# We want to zip up the DSC resource and place it alongside the .json file for deployment
###
Get-ChildItem -Path ..\resourceTemplates | ForEach-Object {
    $templateJson = ($_.FullName + "/" + $_.Name + ".json")

    if(Test-Path $templateJson) {
        Write-Output "Found template $templateJson"

        $template = Get-Content -Path $templateJson | ConvertFrom-Json

        $dscTemplate = $template.variables.templateName

        if($dscTemplate -ne $null) {
            Write-Output "Found DSC Resource Template name: $dscTemplate"

            $pathToDSC = Join-Path -Path "..\DSCSourceFilesForBuild" -ChildPath $dscTemplate

            if(Test-Path $pathToDSC) {
                #Zip the DSC resources and place them here alongside the JSON
                $destpath = Join-Path -Path $_.FullName -ChildPath "$dscTemplate.zip"

                Write-Output "zipping $pathToDSC\* to $destpath"
                
                Compress-Archive -path "$pathToDSC\*" -DestinationPath $destPath -Verbose -Force
            }
            else {
                Write-Output "Cannot find path to DSC: $pathToDSC"
            }
        }
    }
}