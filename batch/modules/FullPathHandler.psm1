# Version: 1.01
Import-Module ./modules/EnvVarHandler.psm1

function DefineFullPaths {
    param (
        [string]$envPath
    )
    try {
        # Relative path of auto commit environment variables
        # Check if $envPath is NULL or if the file does not exist
        $mainDir = Get-Location
        if ([string]::IsNullOrEmpty($envPath) -or !(Test-Path -Path $envPath)) {
            # Define your own variables
            $logDir = "logs"
        } else {
            $logDir = Read-EnvVariable -envPath $envPath -variableName "AUTOLOGDIR"
        }
        # Full path of auto commit environment variables
        $logDirPath = Join-Path -Path $mainDir -ChildPath $logDir
        return $logDirPath, $mainDir
    } catch {
        Write-Error "Failed to define full paths: $_"
        Exit 1
    }
}
# FOR TEST CASE ONLY
# # Call the function with the path to your .env file
# $logDirPath, $autoScriptDirPath = DefineFullPaths -envPath "./.env"

# # Now $logDirPath and $autoScriptDirPath contain the full paths
# Write-Output "Log Directory Path: $logDirPath"
# Write-Output "Script Directory Path: $mainDir"