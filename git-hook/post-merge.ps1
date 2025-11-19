$logFile = "$((Get-Location).Path)\hooks\post-merge.log"

"----" | Out-File $logFile -Append
"{0} - Hi from custom hook folder!" -f (Get-Date) | Out-File $logFile -Append
"----" | Out-File $logFile -Append
