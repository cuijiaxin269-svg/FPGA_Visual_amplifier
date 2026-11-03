$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$texEngine = (Get-Command xelatex -ErrorAction Stop).Source
1..3 | ForEach-Object {
    & $texEngine -interaction=nonstopmode -halt-on-error -file-line-error -jobname=report_competition_review main.tex
    if ($LASTEXITCODE -ne 0) { throw 'XeLaTeX compilation failed; see report_competition_review.log.' }
}
Write-Output (Join-Path $PSScriptRoot 'report_competition_review.pdf')
