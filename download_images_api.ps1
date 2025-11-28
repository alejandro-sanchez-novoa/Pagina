#download_images_api.ps1
# Usa la API de Wikipedia para obtener la imagen principal (original) de una página
# Ejecutar: powershell -ExecutionPolicy Bypass -File .\download_images_api.ps1

$dest = "c:\Users\Alejandro\Pagina\images"
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }

# Lista de páginas y nombres de archivo de salida
$items = @(
    @{title = 'Jan_Oblak'; out = "$dest\\oblak.jpg"},
    @{title = 'Koke_(footballer,_born_1992)'; out = "$dest\\koke.jpg"},
    @{title = 'Fernando_Torres'; out = "$dest\\torres.jpg"},
    @{title = 'Diego_Forl%C3%A1n'; out = "$dest\\forlan.jpg"},
    @{title = 'Metropolitano_Stadium'; out = "$dest\\stadium.jpg"},
    @{title = 'File:Atletico_Madrid_2017_logo.svg'; out = "$dest\\crest.svg"}
)

function Get-ImageFromPage([string]$title) {
    $encoded = [System.Uri]::EscapeDataString($title)
    $api = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=$encoded"
    try {
        $resp = Invoke-WebRequest -Uri $api -UseBasicParsing -ErrorAction Stop
        $json = $resp.Content | ConvertFrom-Json
        foreach ($p in $json.query.pages.PSObject.Properties) {
            $page = $p.Value
            if ($page.PSObject.Properties.Name -contains 'original') {
                return $page.original.source
            }
        }
    } catch {
        Write-Host "Error al consultar API para $title: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    return $null
}

foreach ($it in $items) {
    Write-Host "Procesando $($it.title) ..."
    $url = Get-ImageFromPage -title $it.title
    if (-not $url) {
        # Fallback: si el título empieza por File:, construimos la URL directa para crest SVG
        if ($it.title -like 'File:*') {
            $fname = $it.title.Substring(5)
            $url = "https://upload.wikimedia.org/wikipedia/en/" + $fname
        }
    }
    if ($url) {
        Write-Host "  Descargando: $url -> $($it.out)"
        try {
            Invoke-WebRequest -Uri $url -OutFile $it.out -UseBasicParsing -ErrorAction Stop
        } catch {
            Write-Host "  Error al descargar $url: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  No se encontró imagen para $($it.title)." -ForegroundColor Yellow
    }
}

Write-Host "Script finalizado. Revisa la carpeta images/ y recarga index.html."