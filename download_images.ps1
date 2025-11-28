# Script para descargar imágenes usadas por la página localmente
# Ejecuta este script desde la carpeta del proyecto: .\download_images.ps1

$dest = "c:\Users\Alejandro\Pagina\images"
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }

$files = @(
    @{url = 'https://upload.wikimedia.org/wikipedia/en/f/f4/Atletico_Madrid_2017_logo.svg'; out = "$dest\\crest.svg"},
    @{url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Jan_Oblak_2018.jpg/300px-Jan_Oblak_2018.jpg'; out = "$dest\\oblak.jpg"},
    @{url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Koke_2017.jpg/300px-Koke_2017.jpg'; out = "$dest\\koke.jpg"},
    @{url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Fernando_Torres_2012.jpg/300px-Fernando_Torres_2012.jpg'; out = "$dest\\torres.jpg"},
    @{url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Diego_Fort%C3%BAn.jpg/300px-Diego_Fort%C3%BAn.jpg'; out = "$dest\\forlan.jpg"},
    @{url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Wanda_Metropolitano_interior_2017.jpg/600px-Wanda_Metropolitano_interior_2017.jpg'; out = "$dest\\stadium.jpg"}
)

foreach ($f in $files) {
    Write-Host "Descargando $($f.url) -> $($f.out)"
    try {
        Invoke-WebRequest -Uri $f.url -OutFile $f.out -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  Error al descargar: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "Descarga completada. Abre index.html y recarga la página para ver las imágenes locales."