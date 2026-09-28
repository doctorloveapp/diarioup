param(
    [ValidateSet("demo", "development", "production")]
    [string]$Environment = "demo"
)

$ErrorActionPreference = "Stop"

function Require-EnvironmentValue {
    param([Parameter(Mandatory = $true)][string]$Name)

    $value = [System.Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "Variabile d'ambiente obbligatoria mancante: $Name"
    }
    return $value
}

$keystorePath = Require-EnvironmentValue "DIARIOUP_ANDROID_KEYSTORE_PATH"
$null = Require-EnvironmentValue "DIARIOUP_ANDROID_KEYSTORE_PASSWORD"
$null = Require-EnvironmentValue "DIARIOUP_ANDROID_KEY_ALIAS"
$null = Require-EnvironmentValue "DIARIOUP_ANDROID_KEY_PASSWORD"

$resolvedKeystore = Resolve-Path -LiteralPath $keystorePath -ErrorAction Stop
if (-not (Test-Path -LiteralPath $resolvedKeystore -PathType Leaf)) {
    throw "Il keystore configurato non e un file valido."
}

$flutterArguments = @(
    "build",
    "apk",
    "--release",
    "--target",
    "lib/main.dart",
    "--dart-define=DIARIOUP_ENV=$Environment"
)

if ($Environment -ne "demo") {
    $oauthClientId = Require-EnvironmentValue "DIDUP_OAUTH_CLIENT_ID"
    $redirectUri = Require-EnvironmentValue "DIDUP_REDIRECT_URI"
    $clientVersion = Require-EnvironmentValue "DIDUP_CLIENT_VERSION"
    $flutterArguments += "--dart-define=DIDUP_OAUTH_CLIENT_ID=$oauthClientId"
    $flutterArguments += "--dart-define=DIDUP_REDIRECT_URI=$redirectUri"
    $flutterArguments += "--dart-define=DIDUP_CLIENT_VERSION=$clientVersion"
}

& flutter @flutterArguments
if ($LASTEXITCODE -ne 0) {
    throw "La compilazione Flutter e terminata con codice $LASTEXITCODE."
}

$sourceApk = Join-Path $PSScriptRoot "..\build\app\outputs\flutter-apk\app-release.apk"
if (-not (Test-Path -LiteralPath $sourceApk -PathType Leaf)) {
    throw "APK release non trovato dopo la compilazione."
}

$androidSdkRoot = $env:ANDROID_SDK_ROOT
if ([string]::IsNullOrWhiteSpace($androidSdkRoot)) {
    $localProperties = Join-Path $PSScriptRoot "..\android\local.properties"
    if (Test-Path -LiteralPath $localProperties) {
        $sdkLine = Get-Content -LiteralPath $localProperties |
            Where-Object { $_ -match '^sdk\.dir=' } |
            Select-Object -First 1
        if ($sdkLine) {
            $androidSdkRoot = $sdkLine.Substring("sdk.dir=".Length).Replace('\:', ':').Replace('\\', '\')
        }
    }
}
if ([string]::IsNullOrWhiteSpace($androidSdkRoot)) {
    throw "Android SDK non trovato: imposta ANDROID_SDK_ROOT o android/local.properties."
}

$apksigner = Get-ChildItem -LiteralPath (Join-Path $androidSdkRoot "build-tools") -Filter "apksigner.bat" -Recurse |
    Sort-Object -Property @{ Expression = { [version]$_.Directory.Name }; Descending = $true } |
    Select-Object -First 1
if ($null -eq $apksigner) {
    throw "apksigner.bat non trovato nell'Android SDK."
}

$verificationOutput = & $apksigner.FullName verify --verbose --print-certs $sourceApk 2>&1
$verificationOutput | Write-Output
if ($LASTEXITCODE -ne 0) {
    throw "La verifica crittografica della firma APK non e riuscita."
}
$certificateReport = $verificationOutput -join "`n"
$requiredSubjectValues = @("CN=Dan King", "STREET=Via Roma 1", "L=Roma", "C=IT")
foreach ($requiredValue in $requiredSubjectValues) {
    if (-not $certificateReport.Contains($requiredValue)) {
        throw "Il certificato APK non corrisponde all'identita DiarioUp prevista: manca $requiredValue."
    }
}

$distributionDirectory = Join-Path $PSScriptRoot "..\dist"
New-Item -ItemType Directory -Path $distributionDirectory -Force | Out-Null
$destinationApk = Join-Path $distributionDirectory "DiarioUp-$Environment-release-sideload.apk"
Copy-Item -LiteralPath $sourceApk -Destination $destinationApk -Force

Write-Host "APK release firmato e verificato: $destinationApk"
