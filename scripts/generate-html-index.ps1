param(
	[string]$rulesetRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "ruleset"),
	[string]$htmlRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "html"),
	[string]$templateFile = (Join-Path $PSScriptRoot "html-index.liquid"),
	[string]$renderScript = (Join-Path $PSScriptRoot "render-template.ps1")
)

if (-not (Test-Path -Path $rulesetRoot)) {
	throw "Ruleset directory not found: $rulesetRoot"
}

if (-not (Test-Path -Path $templateFile)) {
	throw "Template file not found: $templateFile"
}

if (-not (Test-Path -Path $renderScript)) {
	throw "Render script not found: $renderScript"
}

if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
	Install-Module -Name powershell-yaml -Scope CurrentUser -Force
}

Import-Module powershell-yaml -ErrorAction Stop

New-Item -ItemType Directory -Path $htmlRoot -Force | Out-Null

$yamlFiles = Get-ChildItem -Path $rulesetRoot -Recurse -File -Include *.yaml |
	Where-Object { $_.Name -ne "rules.schema.yaml" } |
	Sort-Object FullName

if (-not $yamlFiles) {
	Write-Host "No YAML files found in $rulesetRoot"
	return
}

$rulesets = foreach ($yamlFile in $yamlFiles) {
	$relativePath = [System.IO.Path]::GetRelativePath($rulesetRoot, $yamlFile.FullName)
	$relativeDirectory = Split-Path -Parent $relativePath

	$yamlContent = Get-Content -Path $yamlFile.FullName -Raw
	$ruleset = ConvertFrom-Yaml -Yaml $yamlContent -Ordered

	[ordered]@{
		topic = $ruleset.topic
		description = $ruleset.description
		folder = $relativeDirectory -replace "\\", "/"
		rules = @(
			foreach ($rule in $ruleset.rules) {
				[ordered]@{
					id = $rule.id
					title = $rule.title
					href = if ([string]::IsNullOrWhiteSpace($relativeDirectory)) {
						"./{0}.html" -f $rule.id
					}
					else {
						"./{0}/{1}.html" -f (($relativeDirectory -replace "\\", "/"), $rule.id)
					}
				}
			}
		)
	}
}

$indexModel = [ordered]@{
	title = "Power Platform Best Practices"
	subtitle = "Index of all generated HTML rule cards"
	rulesets = @($rulesets | Sort-Object topic)
}

$tempJsonPath = Join-Path ([System.IO.Path]::GetTempPath()) ("rules-index-{0}.json" -f [guid]::NewGuid())
$outputPath = Join-Path $htmlRoot "index.html"

try {
	$indexModel | ConvertTo-Json -Depth 100 | Set-Content -Path $tempJsonPath -Encoding UTF8
	& $renderScript -jsonFile $tempJsonPath -templateFile $templateFile -outputFile $outputPath
	Write-Host "Generated: $outputPath"
}
finally {
	if (Test-Path -Path $tempJsonPath) {
		Remove-Item -Path $tempJsonPath -Force
	}
}
