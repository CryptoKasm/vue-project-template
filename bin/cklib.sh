#!/bin/bash
source ./VERSION

Debug=0
Version="1.1.1-alpha"
Repo="9c-kosmic-headless"

#+---------------------------------------------+#
# CryptoKasm Bash Library                     |#
#+---------------------------------------------+#
# Color Styles
Yellow="\e[33m"
Cyan="\e[36m"
Magenta="\e[35m"
Green="\e[92m"
Red="\e[31m"
RS="\e[0m"
RSL="\e[1A\e["
RSL2="\e[2A\e["
RSL3="\e[3A\e["
sB="\e[1m"

#+-------------------------
# Color Scheme
P=$sB$Yellow
S=$sB$Cyan
T=$sB$Magenta
C=$sB$Green
F=$sB$Red

#+-------------------------
# Spinner
function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"

    case $1 in
        start)
            # calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#2}-60
            # display message and position the cursor in $column column
            #echo -ne $P"|$T --$1    "$RS
            echo -ne $P"|$T --${2}    "$RS
            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "$P\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en $P"\b["$RS
            if [[ $2 -eq 0 ]]; then
                echo -en $C"${on_success}"$RS
            else
                echo -en $F"${on_fail}"$RS
            fi
            echo -e $P"]"$RS
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function startSpinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stopSpinner {
    sleep 0.5
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

#+-------------------------
# Console Text Styles
function sIntro() {
    echo -e $P"+-----------------------------------------------------------------------------+"
    echo -e $P"|$S _________                        __          ____  __.                       "
    echo -e $P"|$S \_   ___ \_______ ___.__._______/  |_  ____ |    |/ _|____    ______ _____   "
    echo -e $P"|$S /    \  \/\_  __ <   |  |\____ \   __\/  _ \|      < \__  \  /  ___//     \  "
    echo -e $P"|$S \     \____|  | \/\___  ||  |_> >  | (  <_> )    |  \ / __ \_\___ \|  Y Y  \ "
    echo -e $P"|$S  \______  /|__|   / ____||   __/|__|  \____/|____|__ (____  /____  >__|_|  / "
    echo -e $P"|$S         \/        \/     |__|                       \/    \/     \/      \/  "
    echo -e $P"+-----------------------------------------------------------------------------+"
    echo -e $P"|$S Project: $REPO   $P|$S Version: $VERSION   $P|$S Platform: $(checkPlatform)"
    echo -e $P"+-----------------------------------------------------------------------------+"$RS
}
function sTitle() {
    echo -e $P">$S $1"$RS
}
function sEntry() {
    echo -e $P"|$T --$1    "$RS
}
function sSpacer() {
    echo -e $P"|"$RS
}
function sL() {
    echo -e $P"+-----------------------------------------+"$RS
}
function sLL() {
    echo -e $P"+-----------------------------------------------------------------------------+"$RS
}
#sExample () {}
#sErorr() {}

function sAction() {
    echo -e $P"|$sB   $1"$RS
}
function sMenuEntry() {
    echo -e $P"|$T $1"$RS
}

#+---------------------------------------------+#
# Functions                                    |#
#+---------------------------------------------+#
# Check if debugging is enabled
function debug() {
    if [ "$Debug" == 1 ]; then 
        echo "$1"
    else
        return
    fi
}

# Throw error code and exit script
function errorZzCode()
{
  echo -e $F">ERROR: $1"$RS 1>&2
  exit 1
}

# Pull new source code from github
gitPull() {
    git pull
    git submodule update --init --recursive
}

# Elevate privilages if not root
function checkRoot() { 
    debug "Check: ROOT"
    if [ "$EUID" -ne 0 ]; then
        sudo echo -ne "\r"
    fi
    debug "Check: ROOT > $EUID"
}

# Check the host platform
function checkPlatform() {
    debug "Check: Platform"
    if grep -q icrosoft /proc/version; then
        PLATFORM="WSL"
    else
        PLATFORM="NATIVE"
    fi
    debug "Check: Platform > $PLATFORM"
    echo $PLATFORM
}

# Check if SECRET exist and load if found
function checkSECRET() {
    if [ -f "SECRET" ]; then
        source ./SECRET
    else
        errCode "SECRET NOT FOUND!"
    fi
}

# Set permissions for this project
function fixPermissions() {
    # Set directory permissions
    sudo find . -type d -exec chmod 755 {} \;

    # Set file permissions
    sudo find . -type f -exec chmod 644 {} \;

    # Set scripts as executable
    sudo find . -name "*.sh" -exec chmod +x {} \;
}

###############################################
function ckMain() {
    sIntro
    sTitle "Building docker image: 9c-kosmic-node"
    startSpinner "pulling source..."
    sleep 5
    stopSpinner $?
    sTitle "Building docker image: 9c-kosmic-explorer"
 
    startSpinner "Testing: Spinner"
    sleep 5
    stopSpinner $?
}
###############################################
#ckMain
