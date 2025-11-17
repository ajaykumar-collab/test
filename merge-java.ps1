param (
    $base = $args[0],
    $ours = $args[1],
    $theirs = $args[2]
)

# Helper: extract methods using regex
function Extract-Methods($content) {
    $text = $content -join "`n"
    $regex = '(?ms)(public|private|protected|static|\s)+[\w\<\>\[\]]+\s+\w+\s*\([^\)]*\)\s*\{.*?\}'
    return [regex]::Matches($text, $regex) | ForEach-Object { $_.Value }
}

# Helper: get imports block
function Extract-Imports($content) {
    return $content | Where-Object { $_ -match '^import ' }
}

# Read files
$oursLines   = Get-Content $ours
$theirsLines = Get-Content $theirs

# Extract imports
$importsOurs   = Extract-Imports $oursLines
$importsTheirs = Extract-Imports $theirsLines

# Combine + dedupe imports
$mergedImports = ($importsOurs + $importsTheirs | Sort-Object -Unique)

# Extract all methods
$methodsOurs   = Extract-Methods $oursLines
$methodsTheirs = Extract-Methods $theirsLines

# Build method dictionary (name -> body)
function MethodDict($methods) {
    $map = @{}
    foreach ($m in $methods) {
        if ($m -match '\s(\w+)\s*\(') {
            $name = $Matches[1]
            $map[$name] = $m
        }
    }
    return $map
}

$mapO = MethodDict $methodsOurs
$mapT = MethodDict $methodsTheirs

# Merge logic:
# ---------------------------------------
# If both changed same method → keep Ours then Theirs version (stacked)
# If only one modified → keep it
# If new method added → include it
# ---------------------------------------

$methodNames = ($mapO.Keys + $mapT.Keys | Sort-Object -Unique)

$mergedMethods = New-Object System.Collections.Generic.List[string]

foreach ($name in $methodNames) {
    $o = $mapO[$name]
    $t = $mapT[$name]

    if ($o -and $t) {
        # SAME method exists in both versions
        if ($o -ne $t) {
            # CHANGED differently -> semantic merge
            $mergedMethods.Add($o)
            $mergedMethods.Add($t)
        } else {
            # identical
            $mergedMethods.Add($o)
        }
    }
    elseif ($o) {
        # only ours
        $mergedMethods.Add($o)
    }
    elseif ($t) {
        # only theirs
        $mergedMethods.Add($t)
    }
}

# Build final output
$final = New-Object System.Collections.Generic.List[string]

# Add package line from ours
$pkg = ($oursLines | Where-Object { $_ -match '^package ' })
if ($pkg) { $final.AddRange($pkg) }

# Add imports
$final.Add("")
$final.AddRange($mergedImports)
$final.Add("")

# Add class signature (from ours)
$classLine = ($oursLines | Where-Object { $_ -match 'class ' }) | Select-Object -First 1
if ($classLine) { $final.Add($classLine) }

$final.Add("{")

# Insert methods cleanly
foreach ($method in $mergedMethods) {
    $final.Add("")
    $final.Add($method.Trim())
}

$final.Add("}")

# Write result
$final | Set-Content $ours
exit 0
