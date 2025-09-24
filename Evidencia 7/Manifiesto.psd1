@{
    # Nombre del módulo
    ModuleVersion = '1.0.0'
    GUID = 'd2c08f33-1234-4567-890a-abcdef123456'
    Author = 'Gilberto Morales Medina 2098206, Roel Guzman 2066072, Emiliano Saracco 2033644'
    CompanyName = 'FCFM'
    Description = 'Módulo forense: eventos, procesos/red, AbuseIPDB'
    
    # Funciones que se exportan para usar fuera del módulo
    FunctionsToExport = @(
        'Get-EventosForenses',
        'Get-ProcesosRedForenses',
        'Get-AbuseIPDBReport'
    )

    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    NestedModules = @()
    RequiredModules = @()

    PrivateData = @{
        PSData = @{
            Tags = @('Forense','Seguridad','PowerShell')
            LicenseUri = ''
            ProjectUri = ''
            ReleaseNotes = 'Versión prueba del módulo'
        }
    }
}

