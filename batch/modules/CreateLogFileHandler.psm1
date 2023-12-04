# Version: 1.01
Import-Module ./modules/FullPathHandler.psm1

function CreateLogFile {
    param (
        [string]$logDirPath,
        [string]$scriptName,
        [string]$logType
    )
    try {
        $logFileName = "${logType}_log_${scriptName}_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
        $logFilePath = Join-Path -Path $logDirPath -ChildPath $logFileName
        return $logFilePath
    } catch {
        Write-Error "Failed to create log file: $_"
        Exit 1
    }
}
# FOR TEST CASE ONLY
# # Call the CreateLogFile function
# $logFilePath = CreateLogFile -logDirPath "./logs" -scriptName "MyScript" -logType "info"

# # Now $logFilePath contains the full path to your log file
# Write-Output "Log File Path: $logFilePath"