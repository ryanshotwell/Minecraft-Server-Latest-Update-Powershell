# Minecraft Server Latest Update Powershell

This script will check the official Minecraft Version Manifest from Mojang to retrieve the latest release version number. It will then download the Minecraft Server jar file to the directory you specify. The script can also update your "run.bat" file to use the newly downloaded jar file.

**:warning: Please make sure your server is not running when updating the server.**

**:warning: Always make backups of your world(s) before updating! I am not responsible for corrupted worlds.**

## Configuration

There are two methods of retrieving information about a Minecraft server.

### $saveJarLocation
This should be set to the directory that the minecraft_server.jar file is located in.
Example: "C:\Games\Minecraft\"

### $updateStartScript
This should be set to a boolean value: $TRUE or $FALSE

### $startServerFile
This should be set to filename for the script that starts the server.
Example: "ServerStart.bat"
