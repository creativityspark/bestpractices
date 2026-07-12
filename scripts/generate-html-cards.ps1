param(
	[string]$rulesetRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "ruleset"),
	[string]$htmlRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "html"),
	[string]$imgRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) "img"),
	[string]$templateFile = (Join-Path $PSScriptRoot "html-card.liquid"),
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

if (-not (Get-Module -ListAvailable -Name MarkdownToHtml)) {
	Install-Module -Name MarkdownToHtml -Scope CurrentUser -Force
}

Import-Module powershell-yaml -ErrorAction Stop
Import-Module MarkdownToHtml -ErrorAction Stop

function Convert-MarkdownToHtmlSafe {
	param([string]$Markdown)

	if ([string]::IsNullOrWhiteSpace($Markdown)) {
		return ""
	}

	return (Convert-MarkdownToHTMLFragment -InputObject $Markdown).HtmlFragment
}

New-Item -ItemType Directory -Path $htmlRoot -Force | Out-Null

$targetImgRoot = Join-Path $htmlRoot "img"
if (Test-Path -Path $imgRoot) {
	if (Test-Path -Path $targetImgRoot) {
		Remove-Item -Path $targetImgRoot -Recurse -Force
	}
	Copy-Item -Path $imgRoot -Destination $targetImgRoot -Recurse -Force
}

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
		$htmlRoot
	}
	else {
		Join-Path $htmlRoot $relativeDirectory
	}

	$segmentCount = if ([string]::IsNullOrWhiteSpace($relativeDirectory)) {
		0
	}
	else {
		(($relativeDirectory -split "[\\/]") | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count
	}

	$assetImgPrefix = if ($segmentCount -eq 0) {
		"./img"
	}
	else {
		("../" * $segmentCount) + "img"
	}

	$indexUrl = if ($segmentCount -eq 0) {
		"./index.html"
	}
	else {
		("../" * $segmentCount) + "index.html"
	}

	New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

	$yamlContent = Get-Content -Path $yamlFile.FullName -Raw
	$ruleset = ConvertFrom-Yaml -Yaml $yamlContent -Ordered

	if (-not $ruleset.rules -or $ruleset.rules.Count -eq 0) {
		continue
	}

	for ($i = 0; $i -lt $ruleset.rules.Count; $i++) {
		$rule = $ruleset.rules[$i]
		$prevRule = if ($i -gt 0) { $ruleset.rules[$i - 1] } else { $null }
		$nextRule = if ($i -lt ($ruleset.rules.Count - 1)) { $ruleset.rules[$i + 1] } else { $null }

		$rule.description_html = Convert-MarkdownToHtmlSafe -Markdown $rule.description

		foreach ($guideline in @($rule.guidelines)) {
			$guideline.text_html = Convert-MarkdownToHtmlSafe -Markdown $guideline.text
		}

		foreach ($rationale in @($rule.rationale)) {
			$rationale.text_html = Convert-MarkdownToHtmlSafe -Markdown $rationale.text
		}

		foreach ($example in @($rule.examples.good) + @($rule.examples.bad)) {
			if (-not $example.code) {
				$example.text_html = Convert-MarkdownToHtmlSafe -Markdown $example.text
			}
		}

		$rationaleCount = @($rule.rationale).Count
		if ($rationaleCount -le 1) {
			$rationaleColumns = "1fr"
		}
		elseif ($rationaleCount -eq 2) {
			$rationaleColumns = "1fr 1fr"
		}
		else {
			$rationaleColumns = "1fr 1fr 1fr"
		}

		$cardModel = [ordered]@{
			topic = $ruleset.topic
			sub_topic = $ruleset.sub_topic
			ruleset_description = $ruleset.description
			breadcrumb_topic = if ([string]::IsNullOrWhiteSpace($relativeDirectory)) { $ruleset.topic } else { ($relativeDirectory -split "[\\/]")[0] }
			breadcrumb_sub_topic = if ($ruleset.sub_topic) { $ruleset.sub_topic } else { $ruleset.topic }
			asset_img_prefix = $assetImgPrefix
			index_url = $indexUrl
			rationale_columns = $rationaleColumns
			prev_url = if ($prevRule) { "./$($prevRule.id).html" } else { "#" }
			next_url = if ($nextRule) { "./$($nextRule.id).html" } else { "#" }
			prev_disabled = if ($prevRule) { "" } else { "disabled" }
			next_disabled = if ($nextRule) { "" } else { "disabled" }
			rule = $rule
		}

		$tempJsonPath = Join-Path ([System.IO.Path]::GetTempPath()) ("rule-card-{0}.json" -f [guid]::NewGuid())
		$targetPath = Join-Path $targetDirectory ("{0}.html" -f $rule.id)

		try {
			$cardModel | ConvertTo-Json -Depth 100 | Set-Content -Path $tempJsonPath -Encoding UTF8
			& $renderScript -jsonFile $tempJsonPath -templateFile $templateFile -outputFile $targetPath
			Write-Host "Generated: $targetPath"
		}
		finally {
			if (Test-Path -Path $tempJsonPath) {
				Remove-Item -Path $tempJsonPath -Force
			}
		}
	}
}
