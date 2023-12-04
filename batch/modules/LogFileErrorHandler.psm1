# Version: 1.01
Import-Module ./modules/CreateLogFileHandler.psm1

function LogFileErrorHandling {
    param (
        [string]$errorMessage,
        [string]$logDir,
        [string]$scriptName,
        [string]$logType
    )
    try {
        # Check if log directory exists, if not, create it
        if (-not (Test-Path -Path $logDir)) {
            New-Item -ItemType Directory -Force -Path $logDir
        }
        
        # Call the CreateLogFile function to get the log file path
        $logFilePath = CreateLogFile -logDirPath $logDir -scriptName $scriptName -logType $logType
        
        # Write the error message to the log file
        $errorMessage | Out-File -Append -FilePath $logFilePath
    } catch {
        Write-Error "Failed to write to log file: $_"
    }
    Write-Error $errorMessage
}
# FOR TEST CASE ONLY
# # Call the LogFileErrorHandling function
# LogFileErrorHandling -errorMessage "An error occurred" -logDir "./logs" -scriptName "MyScript" -logType "error"