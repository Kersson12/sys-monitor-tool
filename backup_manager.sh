#!/bin/bash
# Script: backup_manager.sh
# Objetivo: Comprimir un directorio específico y guardarlo en /backups.
# También se puede programar su ejecución con cron para respaldos automáticos.

# Configura la ruta del directorio a respaldar y la ubicación de los backups
SOURCE_DIR="/home/diker/Documentos"
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${DATE}.tar.gz"

# Crear el directorio de backups si no existe
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Comprimir el directorio
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# Verificar si el backup se realizó correctamente
if [ $? -eq 0 ]; then
    echo "Backup realizado correctamente: $BACKUP_FILE"
else
    echo "Error al realizar el backup" >&2
fi

