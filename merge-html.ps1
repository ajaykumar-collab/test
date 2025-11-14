# merge-html.ps1
# Smart HTML merge: only merge conflicting blocks, not full file

param (
    $base = $args[0],
    $ours = $args[1],
    $theirs = $args[2]
)

# Load the two versions
$oursLines   = Get-Content $ours
$theirsLines = Get-Content $theirs

# Detect conflict block (changes only)
# Find lines that are DIFFERENT between ours and theirs
$diffLines = Compare-Object -ReferenceObject $oursLines -DifferenceObject $theirsLines |
        Where-Object { $_.SideIndicator -eq "=>" } |     # only pick incoming changes
ForEach-Object { $_.InputObject }

# Create the final merged output:
# 1. Keep all the lines from ours (main branch)
# 2. Append only the conflict lines from theirs
$merged = $oursLines + $diffLines

# Write back into final file
$merged | Set-Content $ours
exit 0
