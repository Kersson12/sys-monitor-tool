#!/bin/bash
# Script: log_analyzer.sh
# Objetivo: Analizar logs y buscar patrones de error en /var/log/syslog.
# Utiliza grep, awk y sed para filtrar y formatear la salida.

# Archivo de log a analizar
LOG_FILE="/var/log/syslog"

# Archivo de salida para guardar los resultados del análisis
OUTPUT_FILE="./log_analyzer_output.txt"

echo "Iniciando análisis de errores en $LOG_FILE..."
echo "Resultados del análisis realizados el $(date)" > "$OUTPUT_FILE"
echo "-------------------------------------------------" >> "$OUTPUT_FILE"

# Buscar líneas que contengan "error" (sin importar mayúsculas/minúsculas) y guardarlas
grep -i "error" "$LOG_FILE" > temp_errors.txt

# Verificar si se encontraron errores
if [ -s temp_errors.txt ]; then
    echo "Se encontraron errores en el log." | tee -a "$OUTPUT_FILE"
else
    echo "No se encontraron errores en el log." | tee -a "$OUTPUT_FILE"
fi

# Mostrar y procesar los primeros 10 errores encontrados usando awk para incluir la fecha de la entrada
echo -e "\nPrimeras 10 ocurrencias (con fecha):" | tee -a "$OUTPUT_FILE"
head -n 10 temp_errors.txt | awk '{print $1, $2, $3, $0}' | tee -a "$OUTPUT_FILE"

# Utilizar sed para resaltar la palabra "error" (cambiándola a mayúsculas)
sed 's/error/ERROR/Ig' temp_errors.txt >> "${OUTPUT_FILE%.txt}_formatted.txt"
echo -e "\nSe ha generado un log formateado en ${OUTPUT_FILE%.txt}_formatted.txt" | tee -a "$OUTPUT_FILE"

# Limpiar archivo temporal
rm temp_errors.txt

echo "Análisis completado."
