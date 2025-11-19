# post-merge.ps1
# Run by the post-merge wrapper. If conflicts exist, open IntelliJ.

# Change this to your IntelliJ IDEA exe path if different:
$ideaPath = "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1.1.1\bin\idea64.exe"

# Optional: path to the project to open (repo root)
$projectPath = (Get-Location).Path

# Logging for verification (hook run record)
$logFile = "$projectPath\.git\hooks\post-merge.log"
"{0} - post-merge hook started" -f (Get-Date) | Out-File -FilePath $logFile -Encoding utf8 -Append

# Detect unresolved conflicts (unmerged entries)
$conflicts = git ls-files -u

if ([string]::IsNullOrWhiteSpace($conflicts)) {
    "{0} - no conflicts found" -f (Get-Date) | Out-File -FilePath $logFile -Encoding utf8 -Append
    exit 0
} else {
    "{0} - conflicts detected:" -f (Get-Date) | Out-File -FilePath $logFile -Encoding utf8 -Append
    $conflicts | Out-File -FilePath $logFile -Encoding utf8 -Append

    # Optional: list only .java conflicts (uncomment to filter)
    # $javaConflicts = ($conflicts -split "`n") | Where-Object { $_ -match '\.java' }
    # if (-not $javaConflicts) { exit 0 }

    # Launch IntelliJ
    "{0} - launching IntelliJ: $ideaPath" -f (Get-Date) | Out-File -FilePath $logFile -Encoding utf8 -Append

    Start-Process -FilePath $ideaPath -ArgumentList $projectPath

    # Optionally also open the first conflicted file in IntelliJ by passing file path:
    # $firstFile = ($conflicts -split "\n" | Select-Object -First 1) -replace '^\d+\s+',''
    # Start-Process -FilePath $ideaPath -ArgumentList "$projectPath\$firstFile"
}
