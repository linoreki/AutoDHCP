# AutoDHCP

**AutoDHCP** es un script interactivo desarrollado por **linoreki** que facilita la instalación y configuración de un servidor DHCP en sistemas Ubuntu 24.04.1. Este script automatiza la configuración básica de un servidor DHCP, permitiendo a los usuarios definir parámetros esenciales como la interfaz de red, el rango de direcciones IP, la subred y otros ajustes clave de red.

---

## Características principales

- **Interfaz interactiva:** Solicita al usuario la información necesaria para configurar el servidor DHCP.
- **Automatización:** Instala y configura automáticamente el servicio DHCP (`isc-dhcp-server`).
- **Adaptabilidad:** Permite personalizar parámetros como el rango de IP, subred, puerta de enlace y servidores DNS.
- **Compatibilidad:** Diseñado para Ubuntu 24.04.1.
- **Verificación automática:** Reinicia, habilita y verifica el estado del servicio DHCP.

---

## Requisitos

- Ubuntu 24.04.1.
- Acceso root o privilegios de superusuario.
- Conexión a Internet para instalar paquetes.

---

## Uso

### 1. Descarga del script

Clona el repositorio o descarga el archivo `autodhcp.sh` manualmente:

```bash
git clone https://github.com/linoreki/AutoDHCP.git
cd AutoDHCP
````
2. Asignar permisos de ejecución
Antes de ejecutar el script, asegúrate de asignarle permisos de ejecución:


```bash
chmod +x autodhcp.sh
````
3. Ejecución del script
Ejecuta el script con privilegios de superusuario:


```bash
sudo ./autodhcp.sh
````
4. Proceso interactivo
El script solicitará información como:

Interfaz de red (e.g., eth0).
Rango inicial y final de direcciones IP.
Subred y máscara de red.
Puerta de enlace.
Servidores DNS.
Tiempo de concesión.
Revisa y confirma los datos antes de proceder.

¿Qué hace el script?
Actualiza el sistema:
```bash
apt update && apt upgrade -y
````

Instala el paquete isc-dhcp-server:
```bash
apt install -y isc-dhcp-server
````

Configura /etc/default/isc-dhcp-server: Define la interfaz de red utilizada por el servidor DHCP.
Configura /etc/dhcp/dhcpd.conf: Incluye los parámetros de red como rango de IP, subred, máscara de red, puerta de enlace y servidores DNS.
Reinicia y habilita el servicio DHCP:
```bash
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
````
Verifica el estado del servicio:
```bash
systemctl status isc-dhcp-server
````
Contribuciones
¡Las contribuciones son bienvenidas! Si tienes sugerencias o mejoras, por favor crea un issue o envía un pull request.

Licencia
Este proyecto está licenciado bajo la MIT License.

Autor
Creado por linoreki.
