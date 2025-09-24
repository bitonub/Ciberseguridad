# Editado por bitonub el 23 de Septiembre del 2025

function Validar-Archivo {
    param ([string]$Ruta)

    
    $fecha = Get-Date -Format "ddMMyyyy"
    $reporte = "$PSScriptRoot\Evidencia10_reporte_$fecha.txt"

    try {
        if (Test-Path $Ruta) {
            $contenido = Get-Content $Ruta -ErrorAction Stop
            $mensaje = "Archivo encontrado y accesible: $Ruta"
        } else {
            throw 
        }
    }
    catch {
        $mensaje = "Error en $Ruta : $_"
    }
    finally {
        
        Write-Host "Validación finalizada para: $Ruta"

        
        Add-Content -Path $reporte -Value "$(Get-Date -Format 'HH:mm:ss') - $mensaje"
    }

    return $mensaje
}


# Archivo inexistente
Validar-Archivo -Ruta "C:\archivo_inexistente.txt"

# Archivo en Escritorio
Validar-Archivo -Ruta "$env:USERPROFILE\Desktop\archivo.txt"
