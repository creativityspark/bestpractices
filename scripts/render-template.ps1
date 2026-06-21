# render-template.ps1
# -------------------
# Renders a Liquid template using the Fluid library and JSON data.
#
# PARAMETERS:
#   -jsonFile      Path to JSON data file
#   -templateFile  Path to Liquid template file
#   -outputFile    Path where rendered output will be saved
#
# EXAMPLE USAGE:
#   .\render-template.ps1 -jsonFile .\data.json -templateFile .\template.liquid -outputFile .\output.txt
#
# REQUIREMENTS:
#   - PowerShell 7.0+
#   - .NET 8.0+ runtime
#   - PoSh.FluidTemplateEngine module (will be installed if not present)
#   - Internet access for first run (to download the PS Module)

# Parameters
param(
	[Parameter(Mandatory=$true)]
	[string]$jsonFile,
	[Parameter(Mandatory=$true)]
	[string]$templateFile,
	[Parameter(Mandatory=$true)]
	[Alias("outputFiles")]
	[string]$outputFile
)

if (-not (Get-Module -ListAvailable -Name PoSh.FluidTemplateEngine)) {
    Install-Module -Name PoSh.FluidTemplateEngine -Scope CurrentUser -Force
}

Import-Module PoSh.FluidTemplateEngine -ErrorAction Stop

Set-FluidModuleConfig -Greedy $false

# Read JSON data
$jsonContent = Get-Content $jsonFile -Raw
$data = ConvertFrom-Json $jsonContent

# Liquid works best when an array is wrapped in an object so the template can iterate over rows.
if ($data -is [System.Collections.IEnumerable] -and -not ($data -is [string]) -and -not ($data -is [System.Collections.IDictionary])) {
    $data = [PSCustomObject]@{
        rows = @($data)
    }
}

# Read template
$templateContent = Get-Content $templateFile -Raw

$outputDir = Split-Path -Parent $outputFile
if ($outputDir -and -not (Test-Path -Path $outputDir)) {
	New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$rendered = Format-LiquidString -Source $templateContent -Model $data
Set-Content -Path $outputFile -Value $rendered -Encoding UTF8