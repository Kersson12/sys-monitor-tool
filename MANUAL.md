A continuación, te presento un **Manual.md** que integra toda la información solicitada en la imagen (documentar el proyecto, cómo instalar/ejecutar los scripts, explicación de comandos Bash usados, pantallazos de logs, funcionamiento en distintas distribuciones y visualización del historial de commits en GitHub). Ajusta libremente la redacción o la estructura según tus necesidades. 

---

# Manual de Uso - **sys-monitor-tool**

## 1. Descripción General

Este proyecto (**sys-monitor-tool**) contiene tres scripts Bash para:
- **Monitorear recursos del sistema** (`resource_monitor.sh`).
- **Gestionar respaldos (backups)** (`backup_manager.sh`).
- **Analizar logs** (`log_analyzer.sh`).

Además, se incluye un archivo `cronjobs.txt` con la configuración para automatizar estos scripts usando `crontab`. El objetivo es:
1. **Facilitar el monitoreo de CPU, memoria, disco y red** en tiempo real.  
2. **Realizar respaldos** de manera automática y programada.  
3. **Buscar patrones de error en logs** para identificar problemas del sistema.  
4. **Trabajar colaborativamente con Git/GitHub** (creación de ramas, pull requests, manejo de conflictos).

---

## 2. Requerimientos y Entorno

- **Distribución Linux**: Probado en Ubuntu, Debian y Kali Linux.
- **Git**: Para la gestión de versiones y colaboración.
- **Bash**: Versión 4 o superior.
- **Herramientas adicionales** (instalar según sea necesario):
  - `top`, `df`, `free`, `ifstat` (para monitoreo de recursos).
  - `tar` y `cron` (para respaldos automáticos).
  - `grep`, `awk`, `sed` (para análisis de logs).

En Ubuntu/Debian/Kali, por ejemplo, puedes instalar lo necesario con:
```bash
sudo apt update
sudo apt install git ifstat tar grep awk sed cron
```

---

## 3. Instalación y Configuración

### 3.1 Clonar el repositorio
1. Crea o ubica una carpeta donde quieras alojar el proyecto.  
2. Abre una terminal en esa carpeta y ejecuta:
   ```bash
   git clone https://github.com/<TU-USUARIO>/sys-monitor-tool.git
   cd sys-monitor-tool
   ```

### 3.2 Configurar Git (opcional si no lo has hecho antes)
Si no lo hiciste, configura tu usuario y correo en Git:
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu_correo@example.com"
```

### 3.3 Hacer ejecutables los scripts
Otorga permisos de ejecución a cada script:
```bash
chmod +x resource_monitor.sh
chmod +x backup_manager.sh
chmod +x log_analyzer.sh
```

---

## 4. Ejecución de los Scripts

### 4.1 `resource_monitor.sh`
- **Descripción**: Muestra el uso de CPU, memoria, disco y red en tiempo real, y registra los datos en un archivo de log.  
- **Uso**:  
  ```bash
  ./resource_monitor.sh
  ```
  - Se ejecuta en un bucle que limpia la pantalla y vuelve a mostrar las estadísticas cada cierto intervalo (por defecto cada 5 segundos).
  - También registra la información en `resource_monitor.log` o en `/var/log/system_stats.log` (dependiendo de la ruta configurada en el script).

### 4.2 `backup_manager.sh`
- **Descripción**: Comprime un directorio específico y guarda el archivo en la carpeta `/backups` (o la ruta que configures).  
- **Uso**:  
  ```bash
  ./backup_manager.sh
  ```
  - Verifica que la variable `SOURCE_DIR` en el script apunte al directorio que deseas respaldar.
  - Crea el archivo comprimido con un nombre que incluye fecha y hora (`backup_YYYYMMDD_HHMMSS.tar.gz`).

### 4.3 `log_analyzer.sh`
- **Descripción**: Analiza el archivo `/var/log/syslog` (o el que configures) en busca de la palabra “error” (sin distinguir mayúsculas o minúsculas) y genera dos archivos:  
  - `log_analyzer_output.txt`: contiene el resumen de errores encontrados.  
  - `log_analyzer_output_formatted.txt`: con la palabra “error” resaltada (reemplazada por “ERROR”).  
- **Uso**:  
  ```bash
  ./log_analyzer.sh
  ```
  - Ajusta la variable `LOG_FILE` en el script si quieres analizar otro log.

---

## 5. Explicación de los Comandos Bash Usados

A continuación, se listan los principales comandos y utilidades Bash empleadas:

- **`top`**: Muestra los procesos que consumen más CPU y memoria en tiempo real.  
- **`free`**: Reporta la cantidad de memoria usada y libre.  
- **`df`**: Muestra la cantidad de espacio en disco usado y disponible.  
- **`ifstat`**: Reporta estadísticas de red en tiempo real.  
- **`grep`**: Busca patrones de texto en archivos. Ejemplo:  
  ```bash
  grep -i "error" /var/log/syslog
  ```
- **`awk`**: Procesa y extrae columnas de texto. Ejemplo:
  ```bash
  awk '{print $1, $2}' archivo.txt
  ```
- **`sed`**: Editor de flujo que permite buscar y reemplazar texto. Ejemplo:
  ```bash
  sed 's/error/ERROR/Ig' archivo.txt
  ```
- **`tar`**: Crea o extrae archivos comprimidos. Ejemplo:
  ```bash
  tar -czf backup.tar.gz /ruta/a/respaldar
  ```
- **`cron`**: Da la posibilidad de programar tareas automáticas. Ejemplo:
  ```bash
  crontab -e
  ```
- **`sleep`**: Pausa la ejecución de un script por un número de segundos.

---

## 6. Pantallazos (o ejemplos) de los Logs Generados

### 6.1 Log de Monitoreo de Recursos
Cuando ejecutas `resource_monitor.sh`, se generan entradas similares a:

```
----- Sun Mar 16 12:00:01 UTC 2025 -----
Uso de CPU:
top - 12:00:01 up  1:23,  2 users,  load average: 0.05, 0.10, 0.08
Tasks:  95 total,   1 running,  94 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.2 us,  0.5 sy,  0.0 ni, 98.3 id,  ...
Uso de Memoria:
              total        used        free      shared  buff/cache   available
Mem:           2.0G        1.2G        400M        100M        400M        600M
Swap:          1.0G        200M        800M
Uso de Disco:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        30G   10G   18G  40% /
Actividad de Red:
 Time        eth0
 HH:MM:SS  KB/s in  KB/s out
----------------------------------------
```

### 6.2 Log del Analizador de Logs
Al ejecutar `log_analyzer.sh`, se crea `log_analyzer_output.txt` con un contenido similar a:
```
Resultados del análisis realizados el Sun Mar 16 03:00:00 UTC 2025
-------------------------------------------------
Se encontraron errores en el log.

Primeras 10 ocurrencias (con fecha):
Mar 16 02:59:58 myhostname systemd[1]: ERROR: Failed to ...
...
```
y un archivo `log_analyzer_output_formatted.txt` que resalta “error” como “ERROR”.

### 6.3 Log del Gestor de Backups
Cuando ejecutas `backup_manager.sh`, en pantalla verás:
```
Backup realizado correctamente: /backups/backup_20250316_030000.tar.gz
```
o un mensaje de error si algo falla.

*(Si deseas, puedes incluir capturas de pantalla concretas en lugar de estos ejemplos de texto.)*

---

## 7. Funcionamiento en Diferentes Distribuciones (Ubuntu, Debian, Kali)

Los scripts se han probado exitosamente en:
- **Ubuntu** (20.04 / 22.04)
- **Debian** (10 / 11)
- **Kali Linux**

En cada caso:
1. Verifica que tengas instaladas las herramientas mencionadas (top, df, free, ifstat, grep, awk, sed, tar, cron).
2. Asegúrate de dar permisos de ejecución a los scripts (`chmod +x`).
3. Configura `crontab` si deseas la automatización.  

No se han encontrado diferencias notables en el comportamiento de los scripts entre estas distribuciones, más allá de la instalación de paquetes.

---

## 8. Automatización con Cron

Para automatizar la ejecución de los scripts, edita tu crontab con:
```bash
crontab -e
```
y agrega líneas como las siguientes (ajusta la ruta a tu proyecto):
```cron
# Ejecuta resource_monitor.sh cada hora
0 * * * * /ruta/al/proyecto/resource_monitor.sh >> /ruta/al/proyecto/resource_monitor.log 2>&1

# Ejecuta backup_manager.sh diariamente a las 2:00 AM
0 2 * * * /ruta/al/proyecto/backup_manager.sh >> /ruta/al/proyecto/backup_manager.log 2>&1

# Ejecuta log_analyzer.sh diariamente a las 3:00 AM
0 3 * * * /ruta/al/proyecto/log_analyzer.sh >> /ruta/al/proyecto/log_analyzer.log 2>&1
```

Si deseas que otros vean tu configuración de cron, puedes guardar estas líneas en un archivo llamado `cronjobs.txt` y subirlo al repositorio.

---

## 9. Historial de Commits en GitHub

Para ver el historial de commits:
1. Ve a la página principal de tu repositorio en GitHub.
2. Haz clic en la pestaña **“Commits”** o en el número de commits junto al nombre de la rama (por defecto, **main**).
3. Podrás ver la lista de commits, con fecha, autor y mensaje descriptivo.  

Ejemplo de commit:
```
c5b933a  2 minutes ago  Archivo con el comando para crontab -e
```

---

## 10. Conclusiones

- **sys-monitor-tool** te permite monitorear recursos, respaldar archivos y analizar logs de manera sencilla.
- El uso de **Git y GitHub** facilita el trabajo en equipo, la creación de ramas, la resolución de conflictos y la documentación de cambios.
- La **automatización con cron** ahorra tiempo y reduce la posibilidad de errores humanos.
- Las **pruebas en distintas distribuciones** confirman la portabilidad de los scripts siempre que se cuente con las dependencias necesarias.

¡Gracias por utilizar **sys-monitor-tool**!  
Para dudas o sugerencias, puedes abrir un “Issue” en el repositorio o contactar a los mantenedores del proyecto.

---

**Fin del Manual**  

> **Nota**: Ajusta cualquier ruta o detalle (como correos, nombres, versiones) para que coincida con tu entorno real.  
> Recuerda que puedes incluir capturas de pantalla reales en lugar de los ejemplos de logs si así lo prefieres.
