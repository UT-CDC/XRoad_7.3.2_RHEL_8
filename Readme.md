# Instalador X-ROAD 7.3.2 Security Server - RHEL 8

Script automatizado para la instalación y configuración del Security Server de X-ROAD versión 7.3.2 en sistemas Red Hat Enterprise Linux 8.

## 📋 Requisitos Previos

### Sistema Operativo
- Red Hat Enterprise Linux 8 (RHEL 8)
- Acceso root al sistema

### Conectividad de Red
El script valida automáticamente la conectividad a los siguientes servicios:

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| `xroadcentral.and.gov.co` | 4001 | Central Server |
| `xroadcentral.and.gov.co` | 80 | HTTP Central Server |
| `xroadsecadmin.and.gov.co` | 5500 | Security Server Admin |
| `xroadsecadmin.and.gov.co` | 5577 | Security Server Admin SSL |
| `xroadsecserv.and.gov.co` | 5500 | Security Server Service |
| `xroadsecserv.and.gov.co` | 5577 | Security Server Service SSL |

### Repositorios Externos
- Repositorio EPEL: `https://dl.fedoraproject.org/pub/epel/`
- Repositorio Azure DevOps de X-ROAD Colombia

## 🚀 Instalación

### 1. Descargar el Script
```bash
# Descargar el script de instalación
wget https://ruta-del-script/xroad732_rhel_8.sh
chmod +x xroad732_rhel_8.sh
```

### 2. Ejecutar como Root
```bash
sudo ./xroad732_rhel_8.sh
```

## 🔧 Proceso de Instalación

El script ejecuta automáticamente los siguientes pasos:

### 1. Validación de Permisos
- Verifica que se ejecute con privilegios de root

### 2. Instalación de Dependencias
- **telnet**: Para verificación de conectividad
- **wget**: Para descarga de archivos
- **git**: Para clonación del repositorio

### 3. Validación de Conectividad
- Prueba conexión a todos los servicios requeridos
- Valida acceso a repositorios externos
- **El script se detiene si no se cumplen los criterios de conectividad**

### 4. Configuración del Sistema
- Establece idioma: `en_US.UTF-8`
- Configura zona horaria: `America/Bogota`
- Añade servidor de tiempo: `horalegal.inm.gov.co`
- Instala paquetes de idiomas

### 5. Instalación de Repositorios
- **EPEL**: Para paquetes adicionales
- **Repositorio Local**: Configuración de X-ROAD

### 6. Instalación de Servicios Web
- **nginx**: Servidor web proxy
- **unzip**: Utilidad de descompresión

### 7. Descarga e Instalación de X-ROAD
- Clona repositorio desde Azure DevOps
- Descarga paquetes X-ROAD
- Configura repositorio local
- Instala `xroad-securityserver`

### 8. Configuración de Usuario Administrativo
```bash
# Durante la instalación se solicitará:
Defina usuario: [nombre_usuario]
```

### 9. Configuración de Autologin
- Instala `xroad-autologin`
- Configura PIN de acceso automático
```bash
# Durante la instalación se solicitará:
Inserte PIN: [pin_seguro]
```

### 10. Configuración Final
- Configura puertos de proxy (80, 443)
- Deshabilita firewall
- Reinicia servicios X-ROAD
- Valida servicios activos

## 🔐 Configuración Post-Instalación

### Servicios Instalados
Los siguientes servicios se instalan y configuran automáticamente:
- `xroad-proxy.service`
- `xroad-confclient.service`
- `xroad-monitor.service`
- `xroad-proxy-ui-api.service`
- `xroad-signer.service`

### Puertos Utilizados
| Puerto | Servicio | Descripción |
|--------|----------|-------------|
| 80 | HTTP | Proxy HTTP |
| 443 | HTTPS | Proxy HTTPS |
| 4000 | Admin UI | Interfaz de administración |
| 5500 | Management | Gestión del servidor |
| 5577 | Management SSL | Gestión SSL del servidor |

## 🌐 Acceso al Sistema

Una vez completada la instalación:

```
Acceder a: https://[IP_SERVIDOR]:4000/#/login
```

Donde `[IP_SERVIDOR]` es la dirección IP de tu servidor (se muestra al finalizar la instalación).

## 📁 Estructura de Archivos

```
/opt/rhel/                    # Paquetes X-ROAD
/etc/xroad/                   # Configuración X-ROAD
├── autologin                 # PIN de autologin
└── conf.d/local.ini         # Configuración local
/etc/yum.repos.d/AND-Xroad.repo  # Repositorio local
```

## ⚠️ Consideraciones de Seguridad

- **Firewall**: El script deshabilita firewalld automáticamente
- **PIN Autologin**: Se almacena en `/etc/xroad/autologin`
- **Usuario xroad**: Se configura con shell `/sbin/nologin`

## 🛠️ Solución de Problemas

### Error de Conectividad
Si el script falla en las validaciones de conectividad:
1. Verificar conectividad de red
2. Revisar configuración de proxy/firewall corporativo
3. Contactar al administrador de red

### Error de Repositorios
Si no se puede acceder a los repositorios:
1. Verificar conectividad a Internet
2. Revisar configuración de DNS
3. Validar acceso a repositorios EPEL

### Servicios No Iniciados
Si los servicios X-ROAD no inician:
```bash
# Revisar logs del sistema
journalctl -u xroad-proxy.service
systemctl status xroad-*
```

## 📞 Soporte

Para soporte técnico o reportar problemas:
- Repositorio: Azure DevOps X-ROAD Colombia
- Documentación oficial X-ROAD: [Nordic Institute](https://x-road.global/)

## 📝 Notas de Versión

- **Versión**: X-ROAD 7.3.2
- **SO Soportado**: RHEL 8
- **Última actualización**: 9 de sep 2025

---

**⚠️ Importante**: Este script está diseñado específicamente para la implementación de X-ROAD en Colombia y requiere acceso a infraestructura específica de AND (Agencia Nacional Digital).