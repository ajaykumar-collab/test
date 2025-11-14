# merge-html.ps1
# PowerShell version of union merge for HTML files
# Arguments: $args[0]=base, $args[1]=ours, $args[2]=theirs

# Read files
$ours   = Get-Content $args[1]
$theirs = Get-Content $args[2]

# Combine both versions (simple union)
$merged = $ours + $theirs

# Write the merged result back into OUR file (Git expects this)
$merged | Set-Content $args[1]
