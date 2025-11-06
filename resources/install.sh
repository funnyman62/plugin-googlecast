#!/bin/bash
touch /tmp/dependancy_googlecast_in_progress
echo 0 > /tmp/dependancy_googlecast_in_progress
echo "Launch install of googlecast dependancies (with venv)"
echo ""

# Inclusion des libs Jeedom pour la gestion des dépendances et du venv
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
wget https://raw.githubusercontent.com/NebzHB/dependance.lib/master/dependance.lib --no-cache -O ${BASE_DIR}/dependance.lib &>/dev/null
wget https://raw.githubusercontent.com/NebzHB/dependance.lib/master/pyenv.lib --no-cache -O ${BASE_DIR}/pyenv.lib &>/dev/null
. ${BASE_DIR}/dependance.lib
. ${BASE_DIR}/pyenv.lib

# Configuration du venv (optionnel : version de Python cible, dossier du venv, paquets apt supplémentaires)
# TARGET_PYTHON_VERSION="3.11"  # Décommentez si vous voulez une version spécifique de Python
VENV_DIR=${BASE_DIR}/venv
APT_PACKAGES="sox ffmpeg libavcodec-extra python3-dev python3-venv espeak"

# Lancement de l'installation automatique (venv + dépendances)
launchInstall

# Si vous voulez gérer manuellement chaque étape, utilisez plutôt :
# initPython3
# installOrUpdatePyEnv
# createVenv
# Puis installez les dépendances pip via le venv

# Installation des dépendances Python dans le venv
if [ -f "${VENV_DIR}/bin/pip3" ]; then
    echo "-- Installation des dépendances Python dans le venv"
    ${VENV_DIR}/bin/pip3 install --upgrade pip setuptools
    ${VENV_DIR}/bin/pip3 install 'requests>=2.21.0' 'protobuf==3.20.3' 'zeroconf>=0.38.0' click 'beautifulsoup4>=4.8.1' six tqdm websocket-client casttube redis
    echo 100 > /tmp/dependancy_googlecast_in_progress
    echo "-- Installation des dépendances terminée !"
else
    echo "Erreur : Impossible de créer le venv ou de trouver pip3 dans le venv."
    exit 1
fi

# Misc (création du .htaccess si nécessaire)
BASEDIR="$(dirname "$(dirname "$(readlink -fm "$0")")")"
HTACCESS="$BASEDIR/.htaccess"
if [[ ! -f "$HTACCESS" ]]; then
    echo "Options +FollowSymLinks" >> $HTACCESS
    chown www-data:www-data $HTACCESS
    chmod 644 $HTACCESS
fi

rm -f /tmp/dependancy_googlecast_in_progress
