# Script-principal.ps1
# =====================================
# Menu Forense con exportacion a CSV y PDF
# =====================================

# -------------------------------
# Definir la ruta de la carpeta Reportes
# Si no existe, se crea automáticamente
# -------------------------------
$reportFolder = "$PSScriptRoot\Reportes"
if (!(Test-Path $reportFolder)) {
    New-Item -ItemType Directory -Path $reportFolder | Out-Null
}

# -------------------------------------------
# Funcion: Convert-CSVtoPDF
# Convierte un archivo CSV a PDF usando Excel COM
# Parametros:
#   CsvPath - Ruta del archivo CSV de entrada
#   PdfPath - Ruta del archivo PDF de salida
# -------------------------------------------
function Convert-CSVtoPDF {
    param (
        [string]$CsvPath,
        [string]$PdfPath
    )

    # Crear objeto Excel y abrir archivo CSV
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $workbook = $excel.Workbooks.Open($CsvPath)
    $worksheet = $workbook.Sheets.Item(1)

    # Configurar orientacion de la pagina (1 = vertical)
    $worksheet.PageSetup.Orientation = 1

    # Exportar como PDF
    $workbook.ExportAsFixedFormat(0, $PdfPath)

    # Cerrar libro y Excel
    $workbook.Close($false)
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)

    Write-Host "[+] PDF generado: $PdfPath"
}

# -------------------------------
# Cargar el modulo forense
# -------------------------------
Import-Module "$PSScriptRoot\Modulo.psm1" -Force

# -------------------------------
# Bucle principal del menu
# -------------------------------
do {
    Clear-Host
    Write-Host "===== MENU FORENSE ====="
    Write-Host "1. Extraer eventos del Visor de Eventos"
    Write-Host "2. Analizar procesos y conexiones de red"
    Write-Host "3. Consultar IPs en AbuseIPDB"
    Write-Host "4. Salir"
    Write-Host "========================="
    
    # Leer opcion del usuario
    $opcion = Read-Host "Seleccione una opcion (1-4)"

    switch ($opcion) {

        # -------------------------------
        # Opcion 1: Extraer eventos del Visor
        # -------------------------------
        "1" {
            $logType = Read-Host "Tipo de log (Security, Application, System)"
            $startDate = Read-Host "Fecha inicio (MM/DD/YYYY)"
            $endDate = Read-Host "Fecha fin (MM/DD/YYYY)"
            $reportCsv = "$reportFolder\Eventos.csv"
            $reportPdf = "$reportFolder\Eventos.pdf"

            # Ejecutar la funcion del modulo para extraer eventos
            Get-EventosForenses -LogType $logType -StartDate $startDate -EndDate $endDate -ExportPath $reportCsv

            # Convertir CSV generado a PDF
            Convert-CSVtoPDF -CsvPath $reportCsv -PdfPath $reportPdf

            Read-Host "Presione Enter para continuar..."
        }

        # -------------------------------
        # Opcion 2: Analizar procesos y conexiones de red
        # -------------------------------
        "2" {
            $reportCsv = "$reportFolder\ProcesosRed.csv"
            $reportPdf = "$reportFolder\ProcesosRed.pdf"

            # Ejecutar la funcion del modulo para procesos/red
            Get-ProcesosRedForenses -ExportPath $reportCsv -Format "CSV"

            # Convertir CSV generado a PDF
            Convert-CSVtoPDF -CsvPath $reportCsv -PdfPath $reportPdf

            Read-Host "Presione Enter para continuar..."
        }

        # -------------------------------
        # Opcion 3: Consultar IPs en AbuseIPDB
        # -------------------------------
        "3" {
            # Solicitar lista de IPs y API Key al usuario
            $ipList = Read-Host "Lista de IPs separadas por coma (ej: 8.8.8.8,1.1.1.1)"
            $apiKey = Read-Host "Ingrese su API Key de AbuseIPDB"
            $ipArray = $ipList -split ","
            $reportCsv = "$reportFolder\IPReport.csv"
            $reportPdf = "$reportFolder\IPReport.pdf"

            # Ejecutar la funcion del modulo para consultar IPs
            Get-AbuseIPDBReport -IpList $ipArray -ApiKey $apiKey -ExportPath $reportCsv -Format "CSV"

            # Convertir CSV generado a PDF
            Convert-CSVtoPDF -CsvPath $reportCsv -PdfPath $reportPdf

            Read-Host "Presione Enter para continuar..."
        }

        # -------------------------------
        # Opcion 4: Salir del menu
        # -------------------------------
        "4" {
            Write-Host "Saliendo..."
        }

        # -------------------------------
        # Opcion invalida
        # -------------------------------
        default {
            Write-Host "Opcion invalida. Intente de nuevo."
            Start-Sleep -Seconds 2
        }
    }
} while ($opcion -ne "4")
