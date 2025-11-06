#!/bin/bash
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VENV_DIR="${BASE_DIR}/venv"

# Vérifie que le venv existe et que pip est disponible
if [ ! -f "${VENV_DIR}/bin/pip3" ]; then
    echo "Error: Virtual environment not found at ${VENV_DIR}. Please install dependencies first."
    exit 1
fi

# Met à jour les dépendances dans le venv
echo "-- Updating requirements in venv:"
${VENV_DIR}/bin/pip3 install --upgrade pip
${VENV_DIR}/bin/pip3 install -r $1/requirements.txt

# Gestion du .htaccess (inchangé)
BASEDIR="$(dirname "$(dirname "$(readlink -fm "$0")")")"
HTACCESS="$BASEDIR/.htaccess"
if [[ ! -f "$HTACCESS" ]]; then
    echo "Options +FollowSymLinks" >> $HTACCESS
    chown www-data:www-data $HTACCESS
    chmod 644 $HTACCESS
fi

# Migration des fichiers media (inchangé)
if [[ ! -z "$BASEDIR" ]]; then
    MIGRATION_SRC=$BASEDIR/localmedia
    MIGRATION_DEST=$BASEDIR/data/media
    if [[ -d "$MIGRATION_SRC" ]]; then
        cp -n $MIGRATION_SRC/* $MIGRATION_DEST
        rm -Rf $MIGRATION_SRC
    fi
    OLDTMPDIR=$BASEDIR/tmp
    if [[ -d "$OLDTMPDIR" ]]; then
        rm -f $OLDTMPDIR
    fi
fi
