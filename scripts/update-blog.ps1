# 本地更新 README 博客列表（不依赖 GitHub Actions）
# 用法: powershell -ExecutionPolicy Bypass -File scripts/update-blog.ps1

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$readmePath = Join-Path $repoRoot "README.md"
$feedUrl = "https://blog.csdn.net/TheDan/rss/list"
$maxPosts = 5

Write-Host "Fetching RSS from $feedUrl ..."
[xml]$rss = Invoke-WebRequest -Uri $feedUrl -UseBasicParsing

$posts = $rss.rss.channel.item |
    Select-Object -First $maxPosts |
    ForEach-Object { "- [$($_.title)]($($_.link))" }

$list = ($posts -join "`n")
$content = Get-Content $readmePath -Raw -Encoding UTF8

$pattern = '(?s)(<!-- BLOG-POST-LIST:START -->).*?(<!-- BLOG-POST-LIST:END -->)'
$replacement = "`$1`n$list`n`$2"

if ($content -notmatch $pattern) {
    throw "README.md missing BLOG-POST-LIST markers"
}

$newContent = [regex]::Replace($content, $pattern, $replacement)
Set-Content -Path $readmePath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Updated blog posts in README.md"
