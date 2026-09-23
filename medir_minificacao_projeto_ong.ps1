$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'node_modules')) {
  throw 'Execute npm install antes deste script.'
}

Write-Host 'Gerando build sem minificacao...' -ForegroundColor Cyan
npx vite build --minify=false --outDir dist-unmin
if ($LASTEXITCODE -ne 0) { throw 'Falha na build sem minificacao.' }

Write-Host 'Gerando build minificada...' -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { throw 'Falha na build minificada.' }

function Get-TextAssetBytes([string]$Path) {
  $files = Get-ChildItem $Path -Recurse -File | Where-Object { $_.Extension -in '.html', '.css', '.js' }
  return [double](($files | Measure-Object Length -Sum).Sum)
}

$before = Get-TextAssetBytes 'dist-unmin'
$after = Get-TextAssetBytes 'dist'

if ($before -le 0) { throw 'Nao foi possivel medir a build sem minificacao.' }

$reduction = [math]::Round((($before - $after) / $before) * 100, 2)

Write-Host ''
Write-Host ('Tamanho sem minificacao: {0:N0} bytes' -f $before) -ForegroundColor Yellow
Write-Host ('Tamanho minificado:     {0:N0} bytes' -f $after) -ForegroundColor Yellow
Write-Host ('Reducao aproximada:     {0:N2}%%' -f $reduction) -ForegroundColor Green
Write-Host ''
Write-Host 'Use essa percentagem na resposta da atividade.' -ForegroundColor Cyan
