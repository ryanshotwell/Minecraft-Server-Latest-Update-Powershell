# # # # # # # # #
# Configuration #
$saveJarLocation = "C:\Games\Minecraft\"
# # # # # # # # #


# Get Version Manifest and convert to PowerShell Json Object
$j = Invoke-WebRequest -Uri https://launchermeta.mojang.com/mc/game/version_manifest.json | ConvertFrom-Json

# Get the `latest` -> `release` version from JSON object
$minecraftVersion = $j.latest.release

# Create a web client
$webclient = New-Object System.Net.WebClient

# Determine what the server file name will be
$minecraftJar = "minecraft_server." + $minecraftVersion + ".jar"

# Determine what the URL is to the server jar file
$url = "https://s3.amazonaws.com/Minecraft.Download/versions/" + $minecraftVersion + "/" + $minecraftJar

# Set the location and file name to save the downloaded file to
$jarPath = $saveJarLocation + $minecraftJar

# Using the webclient, download the file in the $url to $jarPath
$webclient.DownloadFile($url, $jarPath)