# merge-html.ps1
# Insert only conflicting lines directly after the changed line

param (
    $base = $args[0],
    $ours = $args[1],
    $theirs = $args[2]
)

$oursLines   = Get-Content $ours
$theirsLines = Get-Content $theirs

# Use Compare-Object to find line-by-line differences
$diff = Compare-Object -ReferenceObject $oursLines -DifferenceObject $theirsLines -IncludeEqual

$final = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $diff.Count; $i++) {

    $item = $diff[$i]

    if ($item.SideIndicator -eq "==") {
        # identical line → keep it
        $final.Add($item.InputObject)
    }
    elseif ($item.SideIndicator -eq "<=") {
        # ours line
        $final.Add($item.InputObject)

        # check if next line is a modification from theirs
        if ($i + 1 -lt $diff.Count -and $diff[$i + 1].SideIndicator -eq "=>") {
            # insert their changed line AFTER ours
            $final.Add($diff[$i + 1].InputObject)
            $i++  # skip the next diff since we already handled it
        }
    }
    elseif ($item.SideIndicator -eq "=>") {
        # theirs line (added only if not part of pair)
        $final.Add($item.InputObject)
    }
}

# Write merged output back into the file Git expects
$final | Set-Content $ours
exit 0
