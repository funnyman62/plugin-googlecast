#!/bin/bash
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VENV_DIR="${BASE_DIR}/venv"

# Vérifie que le venv existe et que son binaire Python est fonctionnel
if [ ! -f "${VENV_DIR}/bin/python3" ]; then
    echo "nok"
    exit 0
fi

# Vérifie que pip est disponible dans le venv
if [ ! -f "${VENV_DIR}/bin/pip3" ]; then
    echo "nok"
    exit 0
fi

# Liste des dépendances requises (à adapter si nécessaire)
REQUIRED_PACKAGES=("zeroconf" "requests" "protobuf" "bs4" "websocket-client" "tqdm" "click" "six" "casttube")
MISSING_PACKAGES=0

# Vérifie chaque dépendance dans le venv
for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! ${VENV_DIR}/bin/pip3 list 2>/dev/null | grep -q "^${package} "; then
        MISSING_PACKAGES=$((MISSING_PACKAGES + 1))
    fi
done

# Si au moins une dépendance est manquante
if [ "$MISSING_PACKAGES" -gt 0 ]; then
    echo "nok"
    exit 0
fi

# Tout est OK
echo "ok"
exit 0
