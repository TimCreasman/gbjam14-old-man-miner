SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

copy_addons() {
    while IFS= read -r line; do
        cp -rn "${SCRIPT_DIR}/../external/${line}" "${SCRIPT_DIR}/../addons/"
    done < "${SCRIPT_DIR}/addon_locations.txt"
}

install_addons() {
    git submodule update --init --recursive
    mkdir -p "${SCRIPT_DIR}/../addons"
    copy_addons
}

install_addons
