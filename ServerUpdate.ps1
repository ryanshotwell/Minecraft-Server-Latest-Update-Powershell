# # # # # # # # # # # # # # # # # # # # #
# # # # # # # CONFIGURATION # # # # # # #
# # # # # # # # # # # # # # # # # # # # #
$saveJarLocation = "C:\Games\Minecraft\"
$updateStartScript = $TRUE
$startServerFile = "ServerStart.bat"
# # # # # # # # # # # # # # # # # # # # #


# Get Version Manifest and convert to PowerShell Json Object
$jsonVersions = Invoke-WebRequest -Uri https://launchermeta.mojang.com/mc/game/version_manifest.json | ConvertFrom-Json

# Get the `latest` -> `release` version from JSON object
$minecraftVersion = $jsonVersions.latest.release

# Create a web client
$webclient = New-Object System.Net.WebClient

# Determine what the server file name will be
$minecraftJar = "minecraft_server." + $minecraftVersion + ".jar"

# Determine what the URL is to the latest server jar file
$url = "https://s3.amazonaws.com/Minecraft.Download/versions/" + $minecraftVersion + "/" + $minecraftJar

# Set the location and file name to save the downloaded file to
$jarPath = $saveJarLocation + $minecraftJar

# Using the webclient, download the file in the $url to $jarPath
$webclient.DownloadFile($url, $jarPath)


# If configuration value of $updateStartScript is True, update the Server Start script with new jar file
if ($updateStartScript)
{
    # Get the contents of the Server Start script
    $startServerContents = [string]::join("`n", (Get-Content $startServerFile))

    # Set the pattern we want to find in the Server Start script so we can determine the version number
    $pattern = "minecraft_server.(.*?).jar"

    # Find the pattern in the Server Start script
    $oldMinecraftVersion = [regex]::match($startServerContents, $pattern).Groups[1].Value

    # Replace the found version number with the new version number
    $startServerContents = $startServerContents -replace $oldMinecraftVersion, $minecraftVersion

    # Write the new start script to the Server Start script file
    $startServerContents | Set-Content $startServerFile
}
else
{
    # Do not update the Server Start script
}