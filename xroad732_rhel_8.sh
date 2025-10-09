#!/bin/bash


REPO_URL="https://github.com/UT-CDC/XRoad_7.3.2_RHEL_8/releases/download/mirror-main-daebc99/rhel.zip"
CLONE_DIR="x-road_colombia_7.3.2_Rhel"
DEST_FILE="/opt/rhel.zip"

echo -e "\n"
echo "==================================================="
echo "=     Instalación X-ROAD 7.3.2   Security Server  ="
echo "==================================================="
sleep 2; echo -e "\n"

if [ `id -u` != 0 ]
then
   echo ""
   echo "Debe ser root para ejecutar el script"
   echo ""
   exit 1
fi

echo "==============================================="
echo "=     Validando criterios de conectividad     ="
echo "==============================================="
sleep 2; echo -e "\n"

tel=$(rpm -qa | grep telnet)
if [[ ! -z $tel ]]; then
  :
else
  echo "=====Paquete Telnet no instalado====="
  sleep 2; echo -e "\n"
  yum -y install telnet
  echo -e "\n"
fi

wgt=$(rpm -qa | grep wget)
if [[ ! -z $wgt ]]; then
  :
  else
  echo "=====Paquete wget no instalado====="
  yum -y install wget
  echo -e "\n"
fi

gitpkg=$(rpm -qa | grep ^git)

if [[ -n $gitpkg ]]; then
  :
else
  echo "===== Paquete git no instalado ====="
  yum -y install git
  echo -e "\n"
fi

tln1=$(timeout 2 telnet xroadcentral.and.gov.co 4001 | awk 'NR == 2 {print $1}')
if [ "$tln1" = "Connected" ]; then
  echo "✅ telnet xroadcentral.and.gov.co 4001 OK"
else
  echo "❌ telnet xroadcentral.and.gov.co 4001 ---->  Bloqueado"
fi
echo "--------------------------------------------"

tln2=$(timeout 2 telnet xroadcentral.and.gov.co 80 | awk 'NR == 2 {print $1}')
if [ "$tln2" = "Connected" ]; then
  echo "✅ telnet xroadcentral.and.gov.co 80 OK"
else
  echo "❌ telnet xroadcentral.and.gov.co 80 ---->  Bloqueado"
fi
echo "--------------------------------------------"

tln3=$(timeout 2 telnet xroadsecadmin.and.gov.co 5500 | awk 'NR == 2 {print $1}')
if [ "$tln3" = "Connected" ]; then
  echo "✅ telnet xroadsecadmin.and.gov.co 5500 OK"
else
  echo "❌ telnet xroadsecadmin.and.gov.co 5500 ---->  Bloqueado"
fi
echo "--------------------------------------------"

tln4=$(timeout 2 telnet xroadsecadmin.and.gov.co 5577 | awk 'NR == 2 {print $1}')
if [ "$tln4" = "Connected" ]; then
  echo "✅ telnet xroadsecadmin.and.gov.co 5577 OK"
else
  echo "❌ telnet xroadsecadmin.and.gov.co 5577 ---->  Bloqueado"
fi
echo "--------------------------------------------"

tln5=$(timeout 2 telnet xroadsecserv.and.gov.co 5500 | awk 'NR == 2 {print $1}')
if [ "$tln5" = "Connected" ]; then
  echo "✅ telnet xroadsecserv.and.gov.co 5500 OK"
else
  echo "❌ telnt xroadsecserv.and.gov.co 5500 ---->  Bloqueado"
fi
echo "--------------------------------------------"

tln6=$(timeout 2 telnet xroadsecserv.and.gov.co 5577 | awk 'NR == 2 {print $1}')
if [ "$tln6" = "Connected" ]; then
  echo "✅ telnet xroadsecserv.and.gov.co 5577 OK"
else
  echo "❌ telnet xroadsecserv.and.gov.co 5577 ---->  Bloqueado"
fi
echo "--------------------------------------------"


#if git ls-remote "$REPO_URL" &>/dev/null; then
#  github=200
#  echo "✅ Conexión repositorio X-Road OK"
#else
#    github=0
#  echo "❌  No se tiene acceso al repositorio de X-Road"
#fi
#echo "--------------------------------------------"

github=$(wget --inet4-only --spider -S --timeout=5 "$REPO_URL" 2>&1 |grep "HTTP/" | awk '{print $2}' | grep 200)
if [ "$github" == "200" ]; then
  echo ""✅ Conexión repositorio X-Road OK""
else
  echo "❌  No se tiene acceso al repositorio de X-Road"
fi
echo "--------------------------------------------"





epel=$(curl -s -k -I --connect-timeout 5 https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm | head -n 1 | awk '{print $2}')
if [ "$epel" == "200" ] || [ "$epel" == "302" ]; then
  echo "✅ Conexión repositorio EPEL  OK"
else
  echo "❌ No se tiene acceso al repositorio EPEL"
fi
echo "--------------------------------------------"
sleep 2; echo -e "\n"





value=("$tln1" "$tln2" "$tln3" "$tln4" "$tln5" "$tln6")
for i in "${value[@]}"; do
    if [ "$i" != "Connected" ]; then
        echo "No se cumplen los criterios de conectividad" ; echo -e "\n"
        exit 1
    fi
done

for i in "$github" "$epel"; do
    if [[ "$i" -ne "200" ]]; then
        echo "No se cumplen los criterios de conectividad"; echo -e "\n"
        exit 1
    fi
done





echo "============================================================"
echo "=     Estableciendo configuración regional del Sistema     ="
echo "============================================================"
sleep 2; echo -e "\n"
localectl set-locale LANG=en_US.UTF-8
timedatectl set-timezone America/Bogota
echo "186.155.28.147 horalegal.inm.gov.co" >> /etc/hosts
timedatectl
sleep 2; echo -e "\n"

echo "========================================="
echo "=     Instalando paquete de idiomas     ="
echo "========================================="
sleep 2; echo -e "\n"
yum install glibc-langpack-en -y
sleep 2; echo -e "\n"

echo "========================================"
echo "=     Configuración de Chrony.conf     ="
echo "========================================"
sleep 2; echo -e "\n"
sed -i '/server/s/^/#/' /etc/chrony.conf 
sed -i '7s/^/\nserver horalegal.inm.gov.co iburst\n/' /etc/chrony.conf
systemctl restart chronyd
sleep 5; 
chronyc sources
echo -e "\n"

echo "======================================="
echo "=     Instalando repositorio EPEL     ="
echo "======================================="
sleep 2; echo -e "\n"
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sleep 2; echo -e "\n"

echo "============================================="
echo "=     Instalando paquetes nginx y unzip     ="
echo "============================================="
sleep 2; echo -e "\n"
yum install -y unzip nginx
systemctl --now enable nginx
sed -i '38,57s/^/# /' /etc/nginx/nginx.conf
sleep 2; echo -e "\n"

echo "======================================"
echo "=     Descargando paquete X-ROAD     ="
echo "======================================"
sleep 2; echo -e "\n"

# Salir si hay error
set -e

echo "=== Descarga binarios ==="
wget -P /opt/ "$REPO_URL" 
echo "✅ Descarga completada...."




cd /opt/
sleep 3
unzip /opt/rhel.zip -d /opt/
cp /opt/rhel/8/x86_64/* /opt/rhel/8/noarch
ls -l /opt/rhel/8/noarch/ | grep "^-" | wc -l
sleep 2; echo -e "\n"
rm -f rhel.zip

echo "=========================================="
echo "=     Configurando repositorio local     ="
echo "=========================================="
sleep 2; echo -e "\n"
yum install createrepo -y 
createrepo /opt/rhel/8/noarch
echo -e "[XRoad-722]
name = Repositorio local XROAD-AND
baseurl = file:///opt/rhel/8/noarch
enabled = 1
gpgcheck = 0" >> /etc/yum.repos.d/AND-Xroad.repo
sleep 2; echo -e "\n"

echo "======================================"
echo "=     Instalando Security Server     ="
echo "======================================"
sleep 2; echo -e "\n"
yum install -y xroad-securityserver
sleep 2; echo -e "\n"

echo "==============================="
echo "=     Creación de usuario     ="
echo "==============================="
sleep 2; echo -e "\n"
read -p "Defina usuario: " user
xroad-add-admin-user $user
sleep 2; echo -e "\n"
echo "---Se ha creado el usuario: "$user"---"
sleep 2; echo -e "\n"

echo "==============================================="
echo "=     Instalando paquete X-ROAD Autologin     ="
echo "==============================================="
sleep 2; echo -e "\n"
yum install -y xroad-autologin
sleep 2; echo -e "\n"

echo "======================================"
echo "=     Configurando PIN Autologin     ="
echo "======================================"
sleep 2; echo -e "\n"
read -sp "Inserte PIN: " code
echo $code > /etc/xroad/autologin
chown xroad:xroad /etc/xroad/autologin
usermod -s /sbin/nologin xroad
sleep 2; echo -e "\n"

echo "==========================="
echo "=     validando nginx     ="
echo "==========================="
sleep 2; echo -e "\n"
echo "[proxy]" >> /etc/xroad/conf.d/local.ini
echo "client-http-port=80" >> /etc/xroad/conf.d/local.ini
echo "client-https-port=443" >> /etc/xroad/conf.d/local.ini
systemctl restart nginx
systemctl status --no-pager nginx
###Disabled Firewalld####
systemctl --now disable firewalld
sleep 2; echo -e "\n"

echo "======================================"
echo "=     Validando servicios X-Road     ="
echo "======================================"
systemctl restart xroad-proxy.service \
xroad-confclient.service \
xroad-monitor.service \
xroad-proxy-ui-api.service \
xroad-signer.service
sleep 5; echo -e "\n"
systemctl list-units "xroad*"
sleep 10; echo -e "\n"

echo "==============================="
echo "=     Verificando puertos     ="
echo "==============================="
sleep 60; echo -e "\n"
ss -tnpl | grep -E '4000|80|443|5500|5577'
sleep 2; echo -e "\n"

#Obteniendo direccion IP del servidor
IP=$(hostname -I | awk '{print $1}')

echo "*****Instalación de Security Server finalizado*****"
echo -e "\n" ; sleep 2

echo "============================================================"
echo "=     Ingresar a -> https://$IP:4000/#/login       ="
echo "============================================================"
echo -e "\n" ; sleep 5
