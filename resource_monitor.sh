#!/bin/bash
# Monitor de Recursos del Sistema en tiempo real
# Este script muestra y registra el uso de CPU, memoria, disco y red en tiempo real en /var/log/system_stats.log

LOG_FILE="/var/log/system_stats.log"

# Verificar permisos para escribir en la ruta del log. Si no tienes permisos, cambia la ruta (por ejemplo, a ~/system_stats.log).
if [ ! -w "$(dirname "$LOG_FILE")" ]; then
  echo "No tienes permisos para escribir en $LOG_FILE. Considera cambiar la ubicación del archivo de log."
  exit 1
fi

while true; do
    clear
    TIMESTAMP="----- $(date) -----"
    echo "$TIMESTAMP" | tee -a "$LOG_FILE"
    
    echo "Uso de CPU:" | tee -a "$LOG_FILE"
    top -b -n1 | head -5 | tee -a "$LOG_FILE"
    
    echo "Uso de Memoria:" | tee -a "$LOG_FILE"
    free -h | tee -a "$LOG_FILE"
    
    echo "Uso de Disco:" | tee -a "$LOG_FILE"
    df -h | tee -a "$LOG_FILE"
    
    echo "Actividad de Red:" | tee -a "$LOG_FILE"
    ifstat -t 1 1 | tee -a "$LOG_FILE"
    
    echo "----------------------------------------" | tee -a "$LOG_FILE"
    
    # Espera 5 segundos antes de la siguiente actualización
    sleep 3
done
