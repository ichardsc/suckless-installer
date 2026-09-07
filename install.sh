#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Configuracion
DWM_REPO="https://github.com/ichardsc/dwm.git"
ST_REPO="https://github.com/ichardsc/st-config.git"
DMENU_REPO="https://git.suckless.org/dmenu"

INSTALL_DIR="$HOME/.local/src"
BIN_DIR="$HOME/.local/bin"

echo -e "${GREEN}Instalando Suckless tools${NC}"

# Crear directorios
mkdir -p "$INSTALL_DIR" "$BIN_DIR"

# Funcion para instalar cada programa
install_program() {
	local repo=$1
	local repo=$2

	echo -e "${GREEN}Instalando $name...${NC}"
	cd "$INSTALL_DIR"
	
	# Verifica si existe el directorio
	# Si existe lo acutaliza, si no, lo clona.
	if [-d "$name" ]; then
		echo "Actualizando $name..."
		cd "$name"
		git pull
	else
		git clone "$repo" "name"
		cd $name
	fi

	# Compilar
	sudo make clean install
}

# Instalar dependencias
echo -e "${GREEN}Instalando dependecias...${NC}"
sudo apt install -y libx11-dev libxft-dev libxinerama-dev feh thunar

# Instalando programas
install_program "$DWM_REPO" "dwm"
install_program "$ST_REPO" "st"
install_program "$DEMU_REPO" "dmenu"

# Copiando script de autostart
echo -e "${GREEN}Configurando autostart...${NC}"
mkdir -p "$HOME/.local/share/dwm"
cp "$INSTALL_DIR/dwm/scripts/autostart.sh" "$HOME/.local/share/dwm"

# Crear enlace simbolico para la barra de estado
if [-f "$INSTALL_DIR/dwm/scripts/bar.sh"]; then
	chmod +x "$INSTALL_DIR/dwm/scripts/bar.sh"
	ln -sf "$INSTALL_DIR/dwm/scripts/bar.sh" "$BIN_DIR/bar.sh"
fi

echo -e "${GREEN}Instalacion completada!"
echo "Para iniciar dwm, agrega lo siguiente en ~/.xinitrc:"
echo "exec dwm"
