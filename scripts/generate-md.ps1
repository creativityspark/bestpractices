param(
	[string]$rulesetRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "ruleset"),
	[string]$markdownRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "markdown"),
	[string]$templateFile = (Join-Path $PSScriptRoot "md-ruleset.liquid"),
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

New-Item -ItemType Directory -Path $markdownRoot -Force | Out-Null

$yamlFiles = Get-ChildItem -Path $rulesetRoot -Recurse -File -Include *.yaml |
	Where-Object { $_.Name -ne "rules.schema.yaml" }

if (-not $yamlFiles) {
	Write-Host "No YAML files found in $rulesetRoot"
	return
}

foreach ($yamlFile in $yamlFiles) {
	$relativePath = [System.IO.Path]::GetRelativePath($rulesetRoot, $yamlFile.FullName)
	$relativeDirectory = Split-Path -Parent $relativePath

	$targetDirectory = if ([string]::IsNullOrWhiteSpace($relativeDirectory)) {
		$markdownRoot
	}
	else {
		Join-Path $markdownRoot $relativeDirectory
	}

	New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

	$targetFileName = "{0}.md" -f [System.IO.Path]::GetFileNameWithoutExtension($yamlFile.Name)
	$targetMarkdownPath = Join-Path $targetDirectory $targetFileName
	$tempJsonPath = Join-Path ([System.IO.Path]::GetTempPath()) ("ruleset-{0}.json" -f [guid]::NewGuid())

	try {
		$yamlContent = Get-Content -Path $yamlFile.FullName -Raw
		$yamlObject = ConvertFrom-Yaml -Yaml $yamlContent -Ordered
		$yamlObject | ConvertTo-Json -Depth 100 | Set-Content -Path $tempJsonPath -Encoding UTF8

		& $renderScript -jsonFile $tempJsonPath -templateFile $templateFile -outputFile $targetMarkdownPath

		Write-Host "Generated: $targetMarkdownPath"
	}
	finally {
		if (Test-Path -Path $tempJsonPath) {
			Remove-Item -Path $tempJsonPath -Force
		}
	}
}
