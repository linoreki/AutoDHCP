#!/bin/bash

# Script interactivo para instalar y configurar un servidor DHCP en Ubuntu 24.04.1
# Debe ejecutarse con privilegios de superusuario (sudo).

# Verificar que el script se ejecute como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecuta este script como root."
    exit 1
fi
echo -e "${GREEN}Adaptadores de red detectados:${NC}"
ip -o link show | awk -F': ' '{print NR". "$2}'
# Pedir datos al usuario
read -p "Ingrese la interfaz de red para el servidor DHCP (e.g., eth0): " INTERFACE
read -p "Ingrese el rango inicial de direcciones IP (e.g., 192.168.1.100): " RANGE_START
read -p "Ingrese el rango final de direcciones IP (e.g., 192.168.1.200): " RANGE_END
read -p "Ingrese la subred (e.g., 192.168.1.0): " SUBNET
read -p "Ingrese la máscara de red (e.g., 255.255.255.0): " NETMASK
read -p "Ingrese la puerta de enlace (router) (e.g., 192.168.1.1): " ROUTER
read -p "Ingrese los servidores DNS separados por comas (e.g., 8.8.8.8,8.8.4.4): " DNS_SERVERS
read -p "Ingrese el tiempo de concesión predeterminado en segundos (e.g., 86400 para 24 horas): " LEASE_TIME

# Confirmar la configuración ingresada
echo "\nResumen de la configuración ingresada:"
echo "Interfaz de red: $INTERFACE"
echo "Rango de direcciones IP: $RANGE_START - $RANGE_END"
echo "Subred: $SUBNET"
echo "Máscara de red: $NETMASK"
echo "Puerta de enlace: $ROUTER"
echo "Servidores DNS: $DNS_SERVERS"
echo "Tiempo de concesión: $LEASE_TIME segundos"
read -p "¿Es correcta esta configuración? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" ]]; then
    echo "Cancelando la configuración."
    exit 1
fi

# Actualizar sistema
echo "\nActualizando el sistema..."
apt update && apt upgrade -y

# Instalar servidor DHCP
echo "\nInstalando el servidor DHCP..."
apt install -y isc-dhcp-server

# Configurar el archivo /etc/default/isc-dhcp-server
echo "\nConfigurando el archivo /etc/default/isc-dhcp-server..."
cat <<EOF > /etc/default/isc-dhcp-server
# Especificar la interfaz a usar por el servidor DHCP
INTERFACESv4="$INTERFACE"
INTERFACESv6=""
EOF

# Configurar el archivo /etc/dhcp/dhcpd.conf
echo "\nConfigurando el archivo /etc/dhcp/dhcpd.conf..."
cat <<EOF > /etc/dhcp/dhcpd.conf
# Configuración principal de DHCP
default-lease-time $LEASE_TIME;
max-lease-time $LEASE_TIME;

# Política de autorización
authoritative;

# Configuración de subred
subnet $SUBNET netmask $NETMASK {
    range $RANGE_START $RANGE_END;
    option routers $ROUTER;
    option subnet-mask $NETMASK;
    option domain-name-servers $DNS_SERVERS;
}
EOF

# Reiniciar el servicio DHCP
echo "\nReiniciando el servicio DHCP..."
systemctl restart isc-dhcp-server

# Habilitar el servicio para que se inicie automáticamente
echo "Habilitando el servicio DHCP para que inicie automáticamente..."
systemctl enable isc-dhcp-server

# Verificar el estado del servicio DHCP
echo "\nVerificando el estado del servicio DHCP..."
systemctl status isc-dhcp-server

# Finalización
echo "\nEl servidor DHCP se instaló y configuró correctamente con la siguiente configuración:"
echo "Interfaz: $INTERFACE"
echo "Rango IP: $RANGE_START - $RANGE_END"
echo "Subred: $SUBNET"
echo "Máscara de red: $NETMASK"
echo "Router: $ROUTER"
echo "DNS: $DNS_SERVERS"
echo "Tiempo de concesión: $LEASE_TIME segundos"