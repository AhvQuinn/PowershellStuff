$path = "C:\Users\Quincy\Desktop"

$items = Get-ChildItem -Path $path -Recurse -Force

$results = foreach ($item in $items) {
    if ($item.PSIsContainer) {
        $size = (Get-ChildItem -Path $item.FullName -Recurse -File -Force |
                 Measure-Object Length -Sum).Sum
    }
    else {
        $size = $item.Length
    }

    [PSCustomObject]@{
        Type     = if ($item.PSIsContainer) { "Directory" } else { "File" }
        FullName = $item.FullName
        SizeBytes = $size
        SizeMB    = "{0:N2}" -f ($size / 1MB)
    }
}

$results | Sort-Object SizeBytes -Descending | Select-Object Type, FullName, SizeMB