
Manual de Uso - sys-monitor-tool

1. Descripción General

El proyecto **sys-monitor-tool** contiene tres scripts Bash diseñados para:

- **Monitorear recursos del sistema** (`resource_monitor.sh`): Muestra el uso de CPU, memoria, disco y red en tiempo real, además de registrar la información en un archivo de log.
- **Gestionar respaldos (backups)** (`backup_manager.sh`): Comprime un directorio específico y guarda el archivo comprimido en una ubicación predeterminada.
- **Analizar logs** (`log_analyzer.sh`): Busca la palabra "error" (sin importar mayúsculas/minúsculas) en un archivo de log (por defecto `/var/log/syslog`) y genera dos archivos: uno con el resumen y otro con el texto formateado.

Además, se incluye un archivo `cronjobs.txt` con la configuración para automatizar la ejecución de estos scripts mediante `cron`.

---
2. Requerimientos y Entorno

- **Sistema Operativo**: Distribuciones Linux (se ha probado en Ubuntu, Debian y Kali Linux).
- **Git**: Para la gestión de versiones y colaboración.
- **Bash**: Versión 4 o superior.
- **Herramientas adicionales**:
  - `top`, `df`, `free`, `ifstat` (para el monitoreo de recursos).
  - `tar` y `cron` (para la gestión de backups).
  - `grep`, `awk`, `sed` (para el análisis de logs).

Para instalar las dependencias en Ubuntu/Debian/Kali, puedes usar:
sudo apt update
sudo apt install git ifstat tar grep awk sed cron

---

3. Instalación y Configuración

 3.1 Clonar el repositorio
	1. Abre una terminal en la carpeta donde deseas alojar el proyecto.
	2. Ejecuta el siguiente comando:

   		git clone https://github.com/<TU-USUARIO>/sys-monitor-tool.git
   		cd sys-monitor-tool
 
 3.2 Configurar Git (si aún no lo has hecho)
Configura tu nombre de usuario y correo electrónico en Git:

	git config --global user.name "Tu Nombre"
	git config --global user.email "tu_correo@example.com"

3.3 Hacer ejecutables los scripts
Otorga permisos de ejecución a cada script:

	chmod +x resource_monitor.sh
	chmod +x backup_manager.sh
	chmod +x log_analyzer.sh


---

4. Ejecución de los Scripts

4.1 `resource_monitor.sh`
- **Descripción**: Muestra en tiempo real el uso de CPU, memoria, disco y red, y registra la información en un archivo de log (por ejemplo, `resource_monitor.log` o `/var/log/system_stats.log`).
- **Uso**:
  ./resource_monitor.sh

- **Detalles**:  
  El script se ejecuta en un bucle continuo que limpia la terminal y actualiza la información cada 5 segundos, mostrando también la salida en la terminal.

4.2 `backup_manager.sh`
- **Descripción**: Comprime un directorio específico y guarda el archivo comprimido en una carpeta (por defecto `/backups` o la ruta que configures).
- **Uso**:

  ./backup_manager.sh

- **Detalles**:  
  Asegúrate de modificar la variable `SOURCE_DIR` en el script para apuntar al directorio que deseas respaldar. El archivo de backup tendrá un nombre que incluye la fecha y hora de creación.

4.3 `log_analyzer.sh`
- **Descripción**: Analiza el archivo de log (por defecto `/var/log/syslog`) en busca de la palabra "error" y genera dos archivos:
  - `log_analyzer_output.txt`: Contiene el resumen de errores encontrados.
  - `log_analyzer_output_formatted.txt`: Presenta el log formateado, resaltando la palabra "error" (convertida a "ERROR").
- **Uso**:
  
  ./log_analyzer.sh
 
- **Detalles**:  
  El script utiliza `grep` para buscar errores, `awk` para procesar las líneas y `sed` para resaltar el texto.

---

5. Explicación de los Comandos Bash Usados

- **`top`**: Muestra los procesos en ejecución y el uso de CPU y memoria.
- **`free`**: Muestra el uso de la memoria del sistema.
- **`df`**: Indica el uso y espacio libre en los sistemas de archivos.
- **`ifstat`**: Reporta estadísticas de la red en tiempo real.
- **`grep`**: Busca patrones de texto en archivos.  
  Ejemplo:  
  
  grep -i "error" /var/log/syslog
  
- **`awk`**: Procesa texto y extrae campos de cada línea.  
  Ejemplo:
  
  awk '{print $1, $2}' archivo.txt
  
- **`sed`**: Permite editar flujos de texto; se usa aquí para reemplazar "error" por "ERROR".  
  Ejemplo:
  
  sed 's/error/ERROR/Ig' archivo.txt
  
- **`tar`**: Crea o extrae archivos comprimidos.  
  Ejemplo:
  
  tar -czf backup.tar.gz /ruta/a/respaldar
 
- **`cron`**: Programa la ejecución automática de tareas.  
  Ejemplo:
  
  crontab -e
  
- **`sleep`**: Pausa la ejecución del script por un número específico de segundos.

---
6. Pantallazos (o Ejemplos) de los Logs Generados

6.1 Log de Monitoreo de Recursos
Ejemplo de salida generada por `resource_monitor.sh`:
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

6.2 Log del Analizador de Logs
Ejemplo de salida generada por `log_analyzer.sh`:
```
Resultados del análisis realizados el Sun Mar 16 03:00:00 UTC 2025
-------------------------------------------------
Se encontraron errores en el log.

Primeras 10 ocurrencias (con fecha):
Mar 16 02:59:58 myhostname systemd[1]: ERROR: Failed to ...
...
```
Se genera además un archivo `log_analyzer_output_formatted.txt` que resalta la palabra "error" como "ERROR".

6.3 Log del Gestor de Backups
Ejemplo de mensaje mostrado por `backup_manager.sh`:
```
Backup realizado correctamente: /backups/backup_20250316_030000.tar.gz
```
En caso de error, se mostrará un mensaje de fallo.

---

7. Funcionamiento en Diferentes Distribuciones

Los scripts han sido probados en:
- **Ubuntu** (20.04 / 22.04)
- **Debian** (10 / 11)
- **Kali Linux**

En cada distribución:
- Asegúrate de tener instaladas las herramientas necesarias (`top`, `df`, `free`, `ifstat`, `grep`, `awk`, `sed`, `tar`, `cron`).
- Otorga permisos de ejecución a los scripts con `chmod +x`.
- Configura correctamente el `crontab` para automatización.

No se han identificado diferencias significativas en el funcionamiento de los scripts entre estas distribuciones.

---

8. Automatización con Cron

Para automatizar la ejecución de los scripts, sigue estos pasos:

1. Abre el editor de crontab:
   
   crontab -e
   
2. Agrega las siguientes líneas (ajustando la ruta a tu proyecto):
   
   # Ejecuta resource_monitor.sh cada hora
   0 * * * * /ruta/al/proyecto/resource_monitor.sh >> /ruta/al/proyecto/resource_monitor.log 2>&1

   # Ejecuta backup_manager.sh diariamente a las 2:00 AM
   0 2 * * * /ruta/al/proyecto/backup_manager.sh >> /ruta/al/proyecto/backup_manager.log 2>&1

   # Ejecuta log_analyzer.sh diariamente a las 3:00 AM
   0 3 * * * /ruta/al/proyecto/log_analyzer.sh >> /ruta/al/proyecto/log_analyzer.log 2>&1
   
3. Guarda y cierra el editor.  
4. Para documentar esta configuración, se ha incluido el archivo `cronjobs.txt` en el repositorio.

---

9. Historial de Commits en GitHub

Para visualizar el historial de commits en el repositorio:

1. Ingresa a la página principal del repositorio en GitHub.
2. Haz clic en la pestaña **"Commits"** o en el número de commits junto al nombre de la rama **main**.
3. Observa la lista de commits con sus respectivos mensajes, fechas y autores.

_Ejemplo de un commit:_

c5b933a  2 minutes ago  Archivo con el comando para crontab -e


---

10. Conclusiones

- **sys-monitor-tool** facilita el monitoreo del sistema, la automatización de respaldos y el análisis de logs mediante scripts Bash.
- La integración de Git y GitHub permite un trabajo colaborativo efectivo, con la gestión de ramas, la resolución de conflictos y un historial de cambios detallado.
- La automatización con `cron` reduce la intervención manual y garantiza la ejecución periódica de tareas.
- La portabilidad de los scripts ha sido verificada en distintas distribuciones Linux, siempre y cuando se cuente con las dependencias necesarias.

---

¡Gracias por utilizar **sys-monitor-tool**!  
Para consultas, sugerencias o reportar errores, abre un "Issue" en el repositorio o contacta a los mantenedores del proyecto.
```
