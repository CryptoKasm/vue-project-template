#!/bin/bash
source bin/cklib.sh

# Show IP and port to access GraphQL
showIP() {
  myIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

  sTitle "Access website via URL: https://localhost"
}

# Displays helpful documentation to use this tool
menuHelp() {
  sTitle "Kosmic Dashboard - Development"
  sMenuEntry "1) Build"
  sMenuEntry "2) Start"
  sMenuEntry "3) Stop"
  sMenuEntry "4) Update"
  sMenuEntry "5) Fix Permissions"
  sMenuEntry "6) Show IP"
  sMenuEntry "7) Clean"
  sMenuEntry "0) Exit"

  read -p "$(echo -e $P"|$sB Choose an option: "$RS)" menuOption

  case $menuOption in

    1)
      npm run build
      exit 0
      ;;

    2)
      npm run serve
      exit 0
      ;;

    3)
      npm stop serve
      exit 0
      ;;

    4)
      gitPull
      exit 0
      ;;

    5)
      fixPermissions
      exit 0
      ;;

    5)
      showIP
      exit 0
      ;;

    7)
      sudo rm -rf logs
      exit 0
      ;;

    0)
      exit 0
      ;;

    *)
      clear
      startMain
      ;;
  esac
}

###############################
startMain() {
  sIntro
  menuHelp
    
}
###############################
case $1 in

  --build)
    buildVue
    buildDocker
    exit 0
    ;;

  --start)
    startDocker
    showIP
    exit 0
    ;;

  --stop)
    docker-compose stop
    exit 0
    ;;

  --update)
    gitPull
    exit 0
    ;;

  --fix-permissions)
    fixPermissions
    exit 0
    ;;

  --show-ip)
    showIP
    exit 0
    ;;

  --clean)
    sudo rm -rf logs
    exit 0
    ;;

  *)
    startMain
    exit 0
    ;;
esac