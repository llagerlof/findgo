#!/usr/bin/env bash

set -u

is_sourced() {
    [[ "${BASH_SOURCE[0]}" != "$0" ]]
}

main() {
    local name match target_dir

    if [[ $# -ne 1 ]]; then
        echo "Usage: source ./findgo.sh <name>"
        return 1
    fi

    name="$1"
    match="$(find . \( -type f -o -type d \) -name "$name" -print -quit)"

    if [[ -z "$match" ]]; then
        echo "File or directory not found: $name"
        return 1
    fi

    if [[ -d "$match" ]]; then
        target_dir="$match"
    else
        target_dir="$(dirname "$match")"
    fi

    if is_sourced; then
        cd "$target_dir" || return 1
        echo "Changed directory to: $(pwd)"
        return 0
    fi

    echo "Found in: $target_dir"
    echo "Run this script with: source ./findgo.sh $name"
}

if is_sourced; then
    main "$@"
    return $?
fi

main "$@"
exit $?