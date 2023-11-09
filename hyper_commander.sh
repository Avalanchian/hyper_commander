#! /usr/bin/env bash

function main() {
    echo "Hello ${USER}!"
    menu
}

function menu() {
    while true; do
        echo "------------------------------"
        echo "| Hyper Commander            |"
        echo "| 0: Exit                    |"
        echo "| 1: OS info                 |"
        echo "| 2: User info               |"
        echo "| 3: File and Dir operations |"
        echo "| 4: Find Executables        |"
        echo "------------------------------"
    
        read -r option
    
        case "$option" in
            0)
                echo "Farewell!"
                return;;
            1)
                uname -no;;
            2)
                whoami;;
            3)
                operations;;
            4)
                executables
                continue;;
            *)
                echo "Invalid option!"
                continue;;
        esac
    done
}

function operations() {
    while true; do
        echo "The list of files and directories:"
        arr=(*)
        for item in ${arr[@]}; do
            if [[ -f "$item" ]]; then
                echo "F $item"
            elif [[ -d "$item" ]]; then
                echo "D $item"
            fi
        done
        echo "---------------------------------------------------"
        echo "| 0 Main menu | 'up' To parent | 'name' To select |"
        echo "---------------------------------------------------"
        read -r option
        name=""
        for item in "${arr[@]}"; do
            if [ "$item" = "$option" ]; then
                name="$item"
                break
            fi
        done
        case "$option" in
            0)
                return;;
            "up")
                cd ..
                continue;;
            "$name")
                if [[ -f "$option" ]]; then
                    file_options_menu "$option"
                    continue
                fi
                    cd "$option"
                    continue;;
            *)
                echo "Invalid input!"
                continue;;
        esac
    done
}

function file_options_menu() {
    while true; do
        echo "---------------------------------------------------------------------"
        echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
        echo "---------------------------------------------------------------------"
        read -r option
        case "$option" in
            0)
                return;;
            1)
                rm -f "$1"
                echo "$1 has been deleted."
                return;;
            2)
                echo "Enter the new file name:"
                read -r new_name
                mv "$1" "$new_name"
                echo "$1 has been renamed as $new_name"
                return;;
            3)
                chmod 666 "$1"
                echo "Permissions have been updated."
                ls -l "$1"
                return;;
            4)
                chmod 664 "$1"
                echo "Permissions have been updated."
                ls -l "$1"
                return;;
            *)
                continue;;
        esac
    done
}

function executables() {
    echo "Enter an executable name:"
    read -r executable
    check_exec=$(which -a "$executable" 2> errors.txt | wc -l)
    if [ "$check_exec" -eq 0 ]; then
        echo "The executable with that name does not exist!"
        return
    else
        echo "Located in: $(which "$executable")"
        echo "Enter arguments:"
        read -r -a arguments
        "$executable" "${arguments[@]}"
        return
    fi
}

main
