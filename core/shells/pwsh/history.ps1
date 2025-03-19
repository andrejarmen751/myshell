# Define the path to your text file
if ($IsWindows) {
    $filePath = "\\wsl$\Debian\$project_path/core/shells/pwsh/HistoryFile.txt"
} else {
    $filePath = "$project_path/core/shells/pwsh/HistoryFile.txt"
}

# Create a temporary file
$tempFilePath = [System.IO.Path]::GetTempFileName()

try {
    # Read the file, filter out empty lines and comments, and remove duplicates
    Get-Content $filePath | 
        Where-Object { $_ -and $_ -notmatch '^\s*#' } | 
        Select-Object -Unique | 
        Set-Content $tempFilePath

    # Replace the original file with the cleaned content
    Move-Item -Path $tempFilePath -Destination $filePath -Force
}
finally {
    # Remove the temporary file if it exists
    if (Test-Path $tempFilePath) {
        Remove-Item $tempFilePath -Force
    }
}