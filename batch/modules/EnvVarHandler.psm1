# Version: 1.01
function Read-EnvVariable {
    param (
        [string]$envPath,
        [string]$variableName
    )
    try {
        $mainDir = Get-Location
        $envPath = Join-Path -Path $mainDir -ChildPath ".env"
        if (!(Test-Path -Path $envPath)) {
            throw "The .env file does not exist at path $envPath"
        }
        $envVars = @{}
        Get-Content -Path $envPath | ForEach-Object {
            $key, $value = $_ -split '='
            $envVars[$key] = $value
        }
        return $envVars[$variableName]
    } catch {
        Write-Error $_.Exception.Message
        Exit 1
    }
}
