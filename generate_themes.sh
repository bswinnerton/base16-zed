#! /bin/bash

check_executable() {
    if command -v "$1" &> /dev/null; then
        return 1
    elif [ -f "$1" ]; then
        return 2
    else
        return 0
    fi
}

# Attempt to locate base16-builder-go executable
check_executable "base16-builder-go"
execution_status=$?

if [ $execution_status -eq 1 ]; then
    # Executable found in $PATH
    base16_builder_path="base16-builder-go"
elif [ $execution_status -eq 2 ]; then
    # Executable found in the current working directory
    base16_builder_path="./base16-builder-go"
else
    # Executable not found, display error message and exit
    echo "base16-builder-go executable not found in \$PATH or in the current directory ($PWD)."
    echo "Please run 'go build' in the base16-builder-go folder or add it to your \$PATH."
    exit 1
fi

# execute base16-builder-go with all arguments passed to this script
"$base16_builder_path" "$@"

# for every theme that ends with _custom.json in themes/ remove the corresponding theme wihout the _custom.json
for theme in themes/*_custom.json; do
    theme_name=$(basename "$theme" _custom.json)
    if [ -f "themes/$theme_name.json" ]; then
        echo "Found custom variant of $theme_name. Removing themes/$theme_name.json"
        rm "themes/$theme_name.json"
    fi
done
