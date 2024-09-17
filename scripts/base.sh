echo_color() {
    local text=$1
    local color=$2
    case $color in
        "red")
            echo -e "\033[31m$text\033[0m"
            ;;
        "green")
            echo -e "\033[32m$text\033[0m"
            ;;
        "yellow")
            echo -e "\033[33m$text\033[0m"
            ;;
        "blue")
            echo -e "\033[34m$text\033[0m"
            ;;
        "magenta")
            echo -e "\033[35m$text\033[0m"
            ;;
        "cyan")
            echo -e "\033[36m$text\033[0m"
            ;;
        *)
            echo "Unknown color: $color"
            ;;
    esac
}

