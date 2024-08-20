#!/usr/bin/env bash

ORANGE='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

function start_keycloak {
  printf "${GREEN} ⬤ Demarrage de Keycloak en cours ...${NC}\r\n"
  [[ "$(docker compose ps | grep keycloak_web | wc -l)" -gt "0" ]] && docker compose down
  docker compose up -d && printf "\r\n${GREEN} ✔${NC} Veuillez patienter quelques secondes "
  $(curl --head --silent --fail http://${IP}:${KEYCLOAK_PORT})
  x=$?
  while [[ $x -ne 0 ]]; do
    sleep 2
    curl --head --silent --fail http://${IP}:${KEYCLOAK_PORT} >/dev/null
    x=$?
    printf "${ORANGE}...${NC}"
  done
  printf "\r\n${GREEN} ✔${NC} KEYCLOAK est dispo via ${ORANGE}http://${IP}:${KEYCLOAK_PORT}${NC}\r\n"
}

function stop_keycloak {
  printf "${GREEN} ⬤ Arrêt keycloak en cours ...${NC}\r\n"
  [[ "$(docker compose ps | grep keycloak_web | wc -l)" -gt "0" ]] && docker compose down && docker compose down --volumes || echo " - Pas de container lancé !!!"
}

function show_docker_images {
  printf "${GREEN} ⬤ Liste des images Docker:${NC}\r\n"
  docker images
}

function change_port {
  read -p $'\e[33m$ ⬤ Entrez le port [Defaut: 8085]: \e[0m' port
  echo "Nouveau port attribué à keycloak: $port"
  export KEYCLOAK_PORT=${port}
  export SILL_KEYCLOAK_URL=http://${IP}:${KEYCLOAK_PORT}
}

function remove_docker_image {
  docker images
  read -p $'\e[33m$ ⬤ Entrez l\'Id ou le nom de l\'image à supprimer: \e[0m' image_id
  echo "Image supprimée: $image_id"
  docker rmi "$image_id"
}

function show_docker_containers {
  printf "${GREEN} ⬤ Liste des  containers Docker:${NC}\r\n"
  docker ps -a
}

function remove_docker_container {
  docker ps -a
  read -p $'\e[33m$ ⬤ Entrez l\'Id ou le nom du container à supprimer: \e[0m' container_id
  echo "Container supprimé: $container_id"
  docker rm "$container_id"
}

function stop_container {
  docker ps -a
  read -p $'\e[33m$ ⬤ Entrez l\'Id ou le nom du container à stopper: \e[0m' container_id
  echo "Container stoppé: $container_id"
  docker stop "$container_id"
}

function stop_all_containers {
  printf "${GREEN} ⬤ Arrêt de tous les containers Docker:${NC}\r\n"
  docker stop $(docker ps -aq)
}

#..........................................................................
# menu
#..........................................................................
while true; do
  #..........................................................................
  # affichage
  #..........................................................................
  clear
  echo -e "\r\n\t ${BLUE}⬤ Keycloak ==============================================${NC} 

\t ${GREEN}u [up]${NC}\t\t\t-->  Démarrer Keycloak
\t ${ORANGE}d [down]${NC}\t\t-->  Arréter Keycloak
\t ${RED}q [quit]${NC}\t\t-->  Quitter

\t ${BLUE}⬤ Container =============================================${NC}

\t ${GREEN}sc [show container]${NC}\t-->  Afficher tous les containers
\t ${ORANGE}so [stop one]${NC}\t\t-->  Arréter un container
\t ${ORANGE}sa [stop all]${NC}\t\t-->  Arréter tous les containers
\t ${RED}rm [remove]${NC}\t\t-->  Supprimer un container

\t ${BLUE}⬤ Image =================================================${NC}

\t ${GREEN}si  [show image]${NC}\t-->  Afficher toutes les images
\t ${RED}rmi [remove image]${NC}\t-->  Supprimer une image

\t ${CYAN}Entrez votre choix: ${NC} \c"

  read answer
  clear

  case "$answer" in
  u | up) start_keycloak ;;
  d | down) stop_keycloak ;;
  q) exit 0 ;;
  show\ container | sc) show_docker_containers ;;
  stop\ one | so) stop_container ;;
  stop\ all | sa) stop_all_containers ;;
  rm | remove) remove_docker_container ;;
  si | show\ image) show_docker_images ;;
  rmi | remove\ image) remove_docker_image ;;
  *) echo "Choisissez une option affichee dans le menu:" ;;
  esac
  echo ""
  echo -e "${CYAN}Touche \"Enter\" pour afficher le menu${NC}"
  read dummy
done
