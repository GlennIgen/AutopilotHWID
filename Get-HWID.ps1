# Define output location
$PC = $env:COMPUTERNAME
$Date = Get-Date -Format "yyyy-MM-dd_HHmmss"
$OutputFolder = "C:\temp"
$OutputFile = "$OutputFolder\$PC-$Date.csv"
# path testing, create folder if missing.
if (!(Test-Path -Path $OutputFolder)) {
   try {
       New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
   } catch {
       Write-Host "Failed to create folder." -ForegroundColor Red
   }
}
# Download script unless existing.
#$ScriptPath = "$env:TEMP\Get-WindowsAutopilotInfo.ps1"
$ScriptPath = "$env:USERPROFILE\Downloads\Get-WindowsAutopilotInfo.ps1"
if (-not (Test-Path $ScriptPath)) {
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/GlennIgen/AutopilotHWID/refs/heads/main/Get-WindowsAutoPilotInfo.ps1" -OutFile $ScriptPath
}
# run script
try {
   PowerShell -ExecutionPolicy Bypass -File $ScriptPath -OutputFile $OutputFile -ErrorAction Stop
   Write-Host "Hardware hash collected and saved to: $OutputFile" -ForegroundColor Green
} catch {
   Write-Host "Error collecting hardware hash: $_" -ForegroundColor Red
}
