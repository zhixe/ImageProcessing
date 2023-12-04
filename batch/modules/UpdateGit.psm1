# Version: 1.01
Import-Module ./modules/LogFileErrorHandler.psm1
Import-Module ./modules/CreateLogFileHandler.psm1
Import-Module ./modules/FullPathHandler.psm1


winget install github.cli
gh auth login
enter
type y
enter
type y
enter
enter


# Prompt the user to enter the directory name
$CurrentWorkingDir = Read-Host -Prompt 'Enter the directory name'

# Navigate to the directory
Set-Location -Path $CurrentWorkingDir

# Create a new repository on GitHub
& gh repo create --public $CurrentWorkingDir


$directoryPath = Get-Location
$directoryName = Split-Path -Path $directoryPath -Leaf
$directoryName


function UpdateToGithub {
    param (
        [string]$mainDir,
        [string]$logDir,
        [string]$logDirPath,
        [string]$autoScriptDirPath
    )

    try {
        Set-Location -Path $mainDir
        Clear-Host

        # Run git pull and check for errors
        $gitPullOutput = & git pull 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "git pull failed with message: $gitPullOutput"
        }

        # Add all changes to git
        $gitAddOutput = & git add . 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "git add failed with message: $gitAddOutput"
        }

        # Commit changes
        $commitMessage = "Update some codes"
        $gitCommitOutput = & git commit -m $commitMessage 2>&1
        if ($LASTEXITCODE -ne 0) {
            # Assuming you want to log the situation where there are no changes to commit
            if ($gitCommitOutput -match 'nothing to commit') {
                Write-Host "No changes to commit."
            } else {
                throw "git commit failed with message: $gitCommitOutput"
            }
        } else {
            Write-Host "Commit successful: $gitCommitOutput"
        }

        # Push changes
        $gitPushOutput = & git push 2>&1
        if ($LASTEXITCODE -ne 0) {
            # Check if the output is the 'Everything up-to-date' message or matches the specific project URL
            if ($gitPushOutput -match 'Everything up-to-date' -or $gitPushOutput -match 'To https:') {
                # It's a regular message, not an error
                Write-Host "Git push status: $gitPushOutput"
            } else {
                # It's an unexpected message, handle it as an error
                throw "git push encountered an issue: $gitPushOutput"
            }
        } else {
            # The operation was successful (based on the exit code)
            Write-Host "Git push successful. Output: $gitPushOutput"
        }

    } catch {
        # If any of the above commands fail, log the error message from the catch block
        $errorMessage = $_.Exception.Message
        LogFileErrorHandling -errorMessage $errorMessage -logFilePath $logDirPath
    }
}