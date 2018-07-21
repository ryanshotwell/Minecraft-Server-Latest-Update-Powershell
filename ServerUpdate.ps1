# # # # # # # # # # # # # # # # # # # # #
# # # # # # # CONFIGURATION # # # # # # #
# # # # # # # # # # # # # # # # # # # # #
$saveJarLocation = "C:\Games\Minecraft\"
$updateStartScript = $TRUE
$startServerFile = "ServerStart.bat"
# # # # # # # # # # # # # # # # # # # # #


# Get Version Manifest and convert to PowerShell JSON Object
$jsonVersions = Invoke-WebRequest -Uri https://launchermeta.mojang.com/mc/game/version_manifest.json | ConvertFrom-Json

# Get the `latest` -> `release` version from JSON object
$minecraftLatestVersion = $jsonVersions.latest.release

# Get all available versions so we can find the latest's data
$minecraftVersions = $jsonVersions.versions

# Loop through each version until we find the latest version
for ($i=0; $i -lt $minecraftVersions.Count; $i++)
{
    # Is this found version id the latest version?
    if ($minecraftVersions[$i].id -eq $minecraftLatestVersion)
    {
        # We found the right version, get its JSON url
        $jsonUrlLatestVersion = $minecraftVersions[$i].url
        
        # Break out of the loop since we have what we need
        break
    }
    else {
        # Keep searching
    }
}

# Get Latest Version Manifest and convert to PowerShell JSON Object
$jsonLatestVersion = Invoke-WebRequest -Uri $jsonUrlLatestVersion | ConvertFrom-Json

# Get the Server Jar URL
$jarUrl = $jsonLatestVersion.downloads.server.url

# Determine what the jar file name will be
$minecraftJar = "minecraft_server." + $minecraftLatestVersion + ".jar"

# Set the location and file name to save the downloaded file to
$jarPath = $saveJarLocation + $minecraftJar

# Create a web client
$webclient = New-Object System.Net.WebClient

# Using the webclient, download the file in the $url to $jarPath
$webclient.DownloadFile($jarUrl, $jarPath)


# If configuration value of $updateStartScript is True, update the Server Start script with new jar file
if ($updateStartScript)
{
    # Get the contents of the Server Start script
    $startServerContents = [string]::join("`n", (Get-Content $startServerFile))

    # Set the pattern we want to find in the Server Start script so we can determine the version number
    $pattern = "minecraft_server.(.*?).jar"

    # Find the pattern in the Server Start script
    $oldminecraftLatestVersion = [regex]::match($startServerContents, $pattern).Groups[1].Value

    # Replace the found version number with the new version number
    $startServerContents = $startServerContents -replace $oldminecraftLatestVersion, $minecraftLatestVersion

    # Write the new start script to the Server Start script file
    $startServerContents | Set-Content $startServerFile
}
else
{
    # Do not update the Server Start script
}
