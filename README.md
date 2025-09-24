# 📌 Scripts de Ciberseguridad en PowerShell

Este repositorio contiene prácticas desarrolladas en **PowerShell** enfocadas en la automatización de tareas y validación dentro del área de **ciberseguridad**. Los proyectos están organizados en dos evidencias principales.  

---

## 📂 Evidencia 7 – Automatización de Reportes de Seguridad

Scripts y módulos para generar reportes de seguridad de forma automática.  

**Archivos principales:**  
- `Manifiesto.psd1` → Archivo de manifiesto del módulo.  
- `Modulo.psm1` → Módulo PowerShell con funciones reutilizables.  
- `Script-principal.ps1` → Script que ejecuta la recopilación de datos y genera reportes.  
- Carpeta **Reportes** con salidas en formato `.csv` y `.pdf`:  
  - Reportes de **eventos del sistema**.  
  - Reportes de **procesos de red activos**.  
  - Reportes de **IPs detectadas**.  

**Objetivo de ciberseguridad:**  
- Automatizar la **recolección y documentación** de eventos del sistema.  
- Monitorear **procesos de red** para identificar actividad sospechosa.  
- Generar reportes en distintos formatos para auditoría y análisis.  

---

## 📂 Evidencia 10 – Validación de Archivos

Script para comprobar la existencia y accesibilidad de archivos en un sistema Windows.  

**Archivos principales:**  
- `Evidencia10_validar_archivos.ps1` → Script de validación de archivos.  
- `Evidencia10_reporte_*.txt` → Reporte con el resultado de la validación.  
- `archivo.txt` → Archivo de prueba.  
- `Evidencia10 (1).pdf` → Evidencia/documentación.  

**Objetivo de ciberseguridad:**  
- Validar integridad y disponibilidad de archivos críticos.  
- Documentar errores y accesos correctos en reportes automáticos.  
- Facilitar auditorías de seguridad en sistemas Windows.  

---

## ✨ Aprendizajes

Durante el desarrollo de estos ejercicios se aprendió a:  
- Crear y estructurar **módulos PowerShell** para reutilización de funciones.  
- Automatizar la **generación de reportes de seguridad** en múltiples formatos.  
- Aplicar **validaciones de archivos y procesos** relevantes en ciberseguridad.  
- Documentar y organizar resultados para auditoría.  

---

## 👨‍💻 Autor

Desarrollado por **Gilberto Morales Medina (Bito)**  
Estudiante de **Seguridad en Tecnologías de la Información** – FCFM, UANL.  
