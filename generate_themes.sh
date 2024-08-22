#!/bin/bash

check_executable() {
    if command -v "$1" &> /dev/null; then
        return 1
    elif [ -f "$1" ]; then
        return 2
    else
        return 0
    fi
}

# Attempt to locate tinted-builder-rust executable
check_executable "tinted-builder-rust"
execution_status=$?

if [ $execution_status -eq 1 ]; then
    # Executable found in $PATH
    tinted_builder_path="tinted-builder-rust"
elif [ $execution_status -eq 2 ]; then
    # Executable found in the current working directory
    tinted_builder_path="./tinted-builder-rust"
else
    # Executable not found, display error message and exit
    echo "tinted-builder-rust executable not found in \$PATH or in the current directory ($PWD)."
    echo "Please install tinted-builder-rust using cargo, Homebrew, or download the binary from the releases page."
    exit 1
fi

# Sync the latest schemes
"$tinted_builder_path" sync

# Build the themes
"$tinted_builder_path" build .

# For every theme that ends with _custom.json in themes/ remove the corresponding theme without the _custom.json
for theme in themes/*_custom.json; do
    theme_name=$(basename "$theme" _custom.json)
    if [ -f "themes/$theme_name.json" ]; then
        echo "Found custom variant of $theme_name. Removing themes/$theme_name.json"
        rm "themes/$theme_name.json"
    fi
done
