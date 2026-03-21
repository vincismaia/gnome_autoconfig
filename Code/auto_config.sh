#!/bin/bash

# Função para exibir o menu
exibir_menu() {
    echo "=================================="
    echo "        MENU DE AUTOMAÇÃO 
         by @vincismaia"
    echo "=================================="
    echo "0) Configurar Terminal"
    echo "1) Atualizar pacotes"
    echo "2) Instalar utilitários"
    echo "3) Instalar pacotes Flatpak"
    echo "4) Configurar GNOME"
    echo "5) Instalar Temas e Extensões (Exige Logout)"
    echo "6) Aplicar Temas (Após o Logout)"
    echo "7) Instalar ZSH"
    echo "8) Sair"
    echo "=================================="
    echo -n "Escolha uma opção: "
}

while true; do
    exibir_menu
    read opcao

    case $opcao in
        0)
            echo "Configurando perfil do terminal..."
            PERFIL_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
            PROFILE_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PERFIL_ID}/"

            gsettings set "$PROFILE_PATH" use-system-font false
            gsettings set "$PROFILE_PATH" font 'Ubuntu Sans Mono 11' 
            gsettings set "$PROFILE_PATH" use-theme-colors false
            gsettings set "$PROFILE_PATH" background-color '#11121A'
            gsettings set "$PROFILE_PATH" foreground-color '#E0E2C8'
            gsettings set "$PROFILE_PATH" use-transparent-background true
            gsettings set "$PROFILE_PATH" background-transparency-percent 10
            gsettings set "$PROFILE_PATH" default-size-columns 148
            gsettings set "$PROFILE_PATH" default-size-rows 37
            ;;
        1)
            echo "Atualizando pacotes do sistema..."
            sudo apt update && sudo apt full-upgrade -y
            sudo apt autoremove -y && sudo apt autoclean
            sudo apt install build-essential dkms -y
            sudo apt install libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
            ;;
        2)
            echo "Instalando utilitários..."
            sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
            sudo apt install htop git curl wget software-properties-common apt-transport-https net-tools iputils-ping traceroute nmap socat flatpak gnome-tweaks gnome-calendar vim python3 gnome-shell-extensions gnome-shell-extension-manager gnome-boxes spice-vdagent fastfetch -y
            
            echo "Configurando Mouse no GRUB..."
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash psmouse.synaptics_intertouch=1"/' /etc/default/grub
            sudo update-grub
            sudo snap install code --classic
            ;;
        3)
            echo "Configurando Flatpaks..."
            sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            
            # Lista de apps para facilitar
            apps=(com.discordapp.Discord org.telegram.desktop org.videolan.VLC org.libreoffice.LibreOffice org.qbittorrent.qBittorrent com.bitwarden.desktop org.mozilla.Thunderbird com.anydesk.Anydesk org.gnome.Extensions)
            
            for app in "${apps[@]}"; do
                flatpak install flathub "$app" -y
            done

            #Adicionar atalhos na Dock
            echo "Organizando atalhos na Dock..."
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/'yelp.desktop', //;s/, 'yelp.desktop'//;s/'yelp.desktop'//")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.gnome.Terminal.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'code_code.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.gnome.Boxes.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.mozilla.Thunderbird.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.libreoffice.LibreOffice.writer.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.libreoffice.LibreOffice.calc.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'com.discordapp.Discord.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.telegram.desktop.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'com.bitwarden.desktop.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'com.anydesk.Anydesk.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/]/, 'org.gnome.Calendar.desktop']/")"
            gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/\]$/, 'virtualbox.desktop']/")"

            #Autostart
#Thunderbird
mkdir -p ~/.config/autostart && cat <<EOF > ~/.config/autostart/thunderbird-flatpak.desktop
[Desktop Entry]
Type=Application
Exec=flatpak run org.mozilla.Thunderbird
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Thunderbird Flatpak
Comment=Iniciar Thunderbird na inicialização
EOF
            ;;
        4)
            echo "Configurando o GNOME..."
            gsettings set org.gnome.shell.extensions.ding show-home false
            gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br'), ('xkb', 'us')]"
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
            gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
            gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
            gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
            gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
            gsettings set org.gnome.mutter center-new-windows true
            gsettings set org.gnome.desktop.interface show-battery-percentage true
            gsettings set org.gnome.desktop.session idle-delay 900
            gsettings set org.gnome.shell.extensions.ding start-corner 'top-left'
            ;;
        5)
            echo "Instalando Temas e Extensões..."
            sudo apt update && sudo apt install gnome-shell-extension-prefs -y
            
            # Instalação manual da Blur My Shell
            mkdir -p ~/.local/share/gnome-shell/extensions
            wget -q https://github.com/aunetx/blur-my-shell/releases/latest/download/blur-my-shell@aunetx.shell-extension.zip -O /tmp/blur.zip
            unzip -o /tmp/blur.zip -d ~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx
            # Instalação do Vitals
            git clone https://github.com/corecoding/Vitals.git ~/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com -b develop
            sudo apt install gnome-shell-extension-manager gir1.2-gtop-2.0 lm-sensors -y
            #PapelDeParede
            mkdir -p "$HOME/Pictures/Wallpaper"
            wget -q -O "$HOME/Pictures/Wallpaper/mountain-abstract.jpg" "https://iili.io/qO6izYu.jpg"
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/Wallpaper/mountain-abstract.jpg"
            gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpaper/mountain-abstract.jpg"
            sleep 1
            #FlatRemixTheme
            git clone https://github.com/daniruiz/flat-remix-gtk.git ~/.themes/FlatRemix
            cp -r ~/.themes/FlatRemix/themes/Flat-Remix-GTK-Blue-Darkest/ ~/.themes/
            cp -r ~/.themes/FlatRemix/themes/Flat-Remix-GTK-Blue-Darkest/libadwaita* ~/.config/gtk-4.0
            gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Darkest"
            clear
            echo "O sistema fará logout em 5 segundos para registrar as extensões."
            sleep 5
            gnome-session-quit --logout --no-prompt
            ;;
        6)
            # Baixar e instalar o tem Marble-blue-dark
            echo "Aplicando Temas..."
            TEMA_MARBLE="Marble-blue-dark"
            
            git clone https://github.com/imarkoff/Marble-shell-theme.git /tmp/Marble-shell-theme
            cd /tmp/Marble-shell-theme && python3 install.py -a --filled
            
            gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 2>/dev/null
            gnome-extensions enable blur-my-shell@aunetx 2>/dev/null
            
            sleep 2
            gsettings set org.gnome.shell.extensions.user-theme name "$TEMA_MARBLE"
            gsettings set org.gnome.desktop.interface gtk-theme "$TEMA_MARBLE"
            sleep 2
            # Baixar e instalar o tema de ícones Colloid
            echo "Baixando o tema de ícones Colloid..."
            git clone https://github.com/vinceliuice/Colloid-icon-theme.git /tmp/Colloid-icons
            cd /tmp/Colloid-icons
            ./install.sh -s default
            gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Dark'
            echo "Tema instalado e aplicado!"
            ;;
        7)
            # Baixar e instalar o ZSH + Tema duellj
            echo "Instalando e configurando o ZSH..."
            sudo apt update && sudo apt install zsh git curl -y
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            sed -i 's/^ZSH_THEME=.*/ZSH_THEME="duellj"/' ~/.zshrc
            sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
            sudo chsh -s $(which zsh) $USER
            clear
            echo "Configuração concluída!"
            echo "O sistema fará logout em 5 segundos para aplicar as mudanças de shell."
            sleep 5
            gnome-session-quit --logout --no-prompt
            ;;    

        8) exit 0 ;;
        *) echo "Opção inválida!" ;;
    esac
    
    echo -e "\nPressione [ENTER] para voltar ao menu..."
    read
    clear
done
