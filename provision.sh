#!/bin/bash

echo "Provision funcionando"
echo "Actualizando sistema..."
apt update -y

echo "Instalando git..."
apt install -y git

echo "Instalando Docker..."
apt install -y docker.io

echo "Configurando permisos Docker..."
usermod -aG docker vagrant

echo "Arrancando Docker..."
systemctl enable docker
systemctl start docker

echo "Instalando Docker Compose..."
apt install -y docker-compose

REPO_URL="https://github.com/rebecadaw/Proyecto-AmpliacionSistemas.git"
REPO_DIR="/home/vagrant/repo-web"
CONTENEDOR="miwordpress"
TEMA="repo-web"

echo "Creando carpeta para el repositorio..."
mkdir -p "$REPO_DIR"
chown -R vagrant:vagrant /home/vagrant

echo "Levantando contenedores..."
cd /vagrant
docker-compose up -d

echo "Esperando unos segundos a que WordPress arranque..."
sleep 15

echo "Clonando o actualizando repositorio..."
if [ -d "$REPO_DIR/.git" ]; then
    cd "$REPO_DIR"
    git fetch origin
    git reset --hard origin/main
else
    rm -rf "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
fi

echo "Creando carpeta del tema dentro del contenedor..."
docker exec "$CONTENEDOR" mkdir -p /var/www/html/wp-content/themes/$TEMA

echo "Copiando archivos del repo al contenedor..."
docker cp "$REPO_DIR/." "$CONTENEDOR":/var/www/html/wp-content/themes/$TEMA
echo "Esperando a que WordPress esté listo..."
sleep 20

echo "Instalando WP-CLI dentro del contenedor..."
docker exec "$CONTENEDOR" bash -c "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
docker exec "$CONTENEDOR" bash -c "chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"

echo "Instalando WordPress automáticamente..."
if ! docker exec "$CONTENEDOR" wp core is-installed --allow-root; then
  docker exec "$CONTENEDOR" wp core install \
    --allow-root \
    --url="http://localhost:8080" \
    --title="Lista de la Compra" \
    --admin_user="admin" \
    --admin_password="admin1234" \
    --admin_email="admin@admin.com"
fi

echo "Activando tema..."
docker exec "$CONTENEDOR" wp theme activate "$TEMA" --allow-root

echo "Provision terminado correctamente"
