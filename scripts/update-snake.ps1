# 本地生成 snake 贡献动画并推到 output 分支（不依赖 GitHub Actions）
# 需要: Docker Desktop
# 用法: powershell -ExecutionPolicy Bypass -File scripts/update-snake.ps1

$ErrorActionPreference = "Stop"
$username = "Thedan-1"
$repoRoot = Split-Path -Parent $PSScriptRoot
$distDir = Join-Path $repoRoot "dist"

Write-Host "Generating snake SVG via Docker ..."
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

docker run --rm `
    -v "${distDir}:/dist" `
    ghcr.io/platane/snk/svg-only `
    "$username" `
    --output dist/github-contribution-grid-snake.svg `
    --output "dist/github-contribution-grid-snake-dark.svg?palette=github-dark"

if ($LASTEXITCODE -ne 0) {
    throw "Docker snk failed. Is Docker Desktop running?"
}

Write-Host "Snake SVG generated in dist/"
Write-Host ""
Write-Host "Next steps (run in repo root):"
Write-Host "  git checkout output 2>$null; if (`$LASTEXITCODE) { git checkout -b output }"
Write-Host "  Copy-Item dist/*.svg . -Force"
Write-Host "  git add *.svg; git commit -m 'update snake'; git push origin output"
Write-Host "  git checkout main"
