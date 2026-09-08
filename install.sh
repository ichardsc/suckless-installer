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
FONTS_DIR="$HOME/.local/share/fonts/JetBrainsMono"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

echo -e "${GREEN}Instalando Suckless tools${NC}"

# Crear directorios
mkdir -p "$INSTALL_DIR" "$BIN_DIR" "$FONTS_DIR" "$WALLPAPER_DIR"

# Funcion para instalar cada programa
install_program() {
	local repo=$1
	local name=$2

	echo -e "${GREEN}Instalando $name...${NC}"
	cd "$INSTALL_DIR"
	
	# Verifica si existe el directorio
	# Si existe lo acutaliza, si no, lo clona.
	if [ -d "$name" ]; then
		echo "Actualizando $name..."
		cd "$name"
		git pull
	else
		git clone "$repo" "$name"
		cd $name
	fi

	# Compilar
	sudo make clean install
}

# Instalar dependencias
echo -e "${GREEN}Instalando dependecias...${NC}"
sudo apt install -y git wget libx11-dev libxft-dev libxinerama-dev build-essential unzip xinit xserver-xorg-core x11-xserver-utils x11-xkb-utils feh thunar

# Instalar Nerd Fonts
echo -e "${GREEN}Instalando JetBrains Mono Nerd Font...${NC}"

# Verificar si ya está instalada
if [ -f "$FONTS_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    echo -e "${GREEN}Las fuentes ya están instaladas. Saltando...${NC}"
else
    # Descargar la fuente
    echo "Descargando JetBrains Mono Nerd Font..."
    wget -q --show-progress -O /tmp/JetBrainsMono.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/JetBrainsMono.zip" || {
        echo -e "${RED}Error al descargar la fuente${NC}"
        exit 1
    }

    # Descomprimir en el directorio de fuentes
    echo "Descomprimiendo fuentes..."
    unzip -q /tmp/JetBrainsMono.zip -d "$FONTS_DIR" || {
        echo -e "${RED}Error al descomprimir la fuente${NC}"
        exit 1
    }

    # Limpiar archivo temporal
    rm /tmp/JetBrainsMono.zip

    # Actualizar caché de fuentes
    echo "Actualizando caché de fuentes..."
    fc-cache -fv

    echo -e "${GREEN}Fuentes instaladas correctamente en $FONTS_DIR${NC}"
fi

# Instalando programas
install_program "$DWM_REPO" "dwm"
install_program "$ST_REPO" "st"
install_program "$DMEMU_REPO" "dmenu"

# Copiando script de autostart
echo -e "${GREEN}Configurando autostart...${NC}"
mkdir -p "$HOME/.local/share/dwm"

if [ -f "$INSTALL_DIR/dwm/scripts/autostart.sh" ]; then
    cp "$INSTALL_DIR/dwm/scripts/autostart.sh" "$HOME/.local/share/dwm/"
    chmod +x "$HOME/.local/share/dwm/autostart.sh"
fi

# Crear enlace simbolico para la barra de estado
if [ -f "$INSTALL_DIR/dwm/scripts/bar.sh"]; then
	chmod +x "$INSTALL_DIR/dwm/scripts/bar.sh"
	ln -sf "$INSTALL_DIR/dwm/scripts/bar.sh" "$BIN_DIR/bar.sh"
fi

# Copiando wallpaper
cp "$INSTALL_DIR/dwm/wallpapers/default-wallpaper.jpg" "$WALLPAPER_DIR/"

echo -e "${GREEN}Instalacion completada!"
echo "Para iniciar dwm, agrega lo siguiente en ~/.xinitrc:"
echo "exec dwm"
