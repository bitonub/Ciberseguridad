# -----------------------------
# Modulo Forense - Proyecto FCFM
# Funciones: Eventos, Procesos/Red, AbuseIPDB
# -----------------------------

Set-StrictMode -Version Latest

# -------------------------------------------
# Funcion 1: Extraccion de eventos del Visor
# -------------------------------------------
function Get-EventosForenses {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Security","Application","System")]
        [string]$LogType,

        [Parameter(Mandatory=$true)]
        [datetime]$StartDate,

        [Parameter(Mandatory=$true)]
        [datetime]$EndDate,

        [string]$ExportPath = "$PSScriptRoot\Reportes\Eventos.csv",
        [ValidateSet("CSV","HTML")] [string]$Format = "CSV"
    )

    try {
        Write-Host "[+] Extrayendo eventos de $LogType entre $StartDate y $EndDate ..."
        $events = Get-WinEvent -LogName $LogType | Where-Object { $_.TimeCreated -ge $StartDate -and $_.TimeCreated -le $EndDate }
        $eventsArray = @($events)  # Asegura que sea un array

        if ($eventsArray.Count -eq 0) {
            Write-Error "No se encontraron eventos que coincidan con los criterios especificados."
            return
        }

        $sospechosos = $eventsArray | Where-Object { $_.Id -in 4625, 4672 } # ejemplo de IDs sospechosos

        Write-Host "[+] Total de eventos encontrados: $($eventsArray.Count)"
        Write-Host "[!] Posibles eventos sospechosos detectados: $($sospechosos.Count)"

        switch ($Format) {
            "CSV"  { $eventsArray | Export-Csv -Path $ExportPath -NoTypeInformation -Force }
            "HTML" { $eventsArray | ConvertTo-Html | Out-File -FilePath $ExportPath -Force }
        }

        Write-Host "[+] Eventos exportados a $ExportPath"
    }
    catch {
        Write-Error "Ocurrio un error: $_"
    }
}

# -------------------------------------------------
# Funcion 2: Correlacion de procesos y conexiones
# -------------------------------------------------
function Get-ProcesosRedForenses {
    param(
        [string]$ExportPath = "$PSScriptRoot\Reportes\ProcesosRed.csv",
        [ValidateSet("CSV","HTML")] [string]$Format = "CSV"
    )

    try {
        Write-Host "[+] Obteniendo procesos y conexiones de red..."

        $procesos = Get-Process | Select-Object Id, ProcessName, Path
        $conexiones = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess

        # Correlacion de procesos con conexiones
        $resultado = foreach ($p in $procesos) {
            $conns = $conexiones | Where-Object { $_.OwningProcess -eq $p.Id }
            if ($conns) {
                foreach ($c in $conns) {
                    [PSCustomObject]@{
                        ProcessId     = $p.Id
                        ProcessName   = $p.ProcessName
                        Path          = $p.Path
                        LocalAddress  = $c.LocalAddress
                        LocalPort     = $c.LocalPort
                        RemoteAddress = $c.RemoteAddress
                        RemotePort    = $c.RemotePort
                        State         = $c.State
                    }
                }
            } else {
                [PSCustomObject]@{
                    ProcessId     = $p.Id
                    ProcessName   = $p.ProcessName
                    Path          = $p.Path
                    LocalAddress  = ""
                    LocalPort     = ""
                    RemoteAddress = ""
                    RemotePort    = ""
                    State         = ""
                }
            }
        }

        $sospechosos = $procesos | Where-Object { -not $_.Path -or $_.Path -eq "" }
        Write-Host "[+] Procesos analizados: $($procesos.Count)"
        Write-Host "[!] Sospechosos detectados: $($sospechosos.Count)"

        switch ($Format) {
            "CSV" { $resultado | Export-Csv -Path $ExportPath -NoTypeInformation -Force }
            "HTML" { $resultado | ConvertTo-Html | Out-File -FilePath $ExportPath -Force }
        }

        Write-Host "[+] Informe exportado en $Format a $ExportPath"
    }
    catch {
        Write-Error "Ocurrio un error: $_"
    }
}

# -----------------------------------------
# Funcion 3: Consulta de IPs en AbuseIPDB
# -----------------------------------------
function Get-AbuseIPDBReport {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$IpList,

        [Parameter(Mandatory=$true)]
        [string]$ApiKey,

        [string]$ExportPath = "$PSScriptRoot\Reportes\IPReport.csv",
        [ValidateSet("CSV","HTML")] [string]$Format = "CSV"
    )

    try {
        $resultado = @()
        foreach ($ip in $IpList) {
            Write-Host "[+] Consultando IP: $ip ..."
            try {
                $response = Invoke-RestMethod -Uri "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip&maxAgeInDays=90" `
                                              -Headers @{ "Key" = $ApiKey; "Accept" = "application/json" }

                $data = $response.data
                $resultado += [PSCustomObject]@{
                    IP                   = $data.ipAddress
                    Country              = $data.countryCode
                    IsWhitelisted        = $data.isWhitelisted
                    AbuseConfidenceScore = $data.abuseConfidenceScore
                    TotalReports         = $data.totalReports
                    LastReportedAt       = $data.lastReportedAt
                }
            }
            catch {
                Write-Warning "No se pudo consultar $ip`: $($_)"
            }
        }

        switch ($Format) {
            "CSV" { $resultado | Export-Csv -Path $ExportPath -NoTypeInformation -Force }
            "HTML" { $resultado | ConvertTo-Html | Out-File -FilePath $ExportPath -Force }
        }

        Write-Host "[+] Informe exportado en formato $Format a $ExportPath"
        Write-Host "[+] Total de IPs procesadas: $($resultado.Count)"
    }
    catch {
        Write-Error "Ocurrio un error general: $_"
    }
}

# -------------------------------
# Exportar funciones del modulo
# -------------------------------
Export-ModuleMember -Function Get-EventosForenses, Get-ProcesosRedForenses, Get-AbuseIPDBReport
