# merge-html.ps1
# Insert the conflicting lines exactly after their position in ours
param (
    $base = $args[0],
    $ours = $args[1],
    $theirs = $args[2]
)

$oursLines   = Get-Content $ours
$theirsLines = Get-Content $theirs

$final = New-Object System.Collections.Generic.List[string]

# Use Compare-Object to detect differences
$diff = Compare-Object $oursLines $theirsLines -IncludeEqual -SyncWindow 0

$index = 0

while ($index -lt $diff.Count) {
    $item = $diff[$index]

    if ($item.SideIndicator -eq "==") {
        # identical line → keep it
        $final.Add($item.InputObject)
    }
    elseif ($item.SideIndicator -eq "<=") {
        # ours line: ALWAYS add it
        $final.Add($item.InputObject)

        # If next diff entry is theirs, place it RIGHT AFTER ours
        if ($index + 1 -lt $diff.Count -and $diff[$index + 1].SideIndicator -eq "=>") {
            $final.Add($diff[$index + 1].InputObject)
            $index++
        }
    }
    elseif ($item.SideIndicator -eq "=>") {
        # theirs lone line (new line not in ours)
        # insert where it belongs
        $final.Add($item.InputObject)
    }
    $index++
}

$final | Set-Content $ours
exit 0
