#!/usr/bin/env bash

ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

options=(
  "Demarrer Keycloak"
  "Arreter Keycloak"
  "Revoir les options"
  #"Liste des ports utilisés"
  #"Changer de port"
  "Afficher les containers Docker"
  "Supprimer un container Docker"
  "Arreter tous les containers Docker"
  "Afficher les images Docker"
  #"Supprimer une image Docker"
  "Quitter"
)

function start_keycloak {
  printf "${GREEN} ⬤ Demarrage de Keycloak en cours ...${NC}\r\n"
  [[ "$(docker compose ps | grep keycloak_web | wc -l)" -gt "0" ]] && docker compose down
  docker compose up -d && printf "\r\n${GREEN} ✔${NC} Veuillez patienter quelques secondes "
  $(curl --head --silent --fail http://localhost:${KEYCLOAK_PORT})
  x=$?
  while [[ $x -ne 0 ]]; do
    sleep 2
    curl --head --silent --fail http://localhost:${KEYCLOAK_PORT} >/dev/null
    x=$?
    printf "${ORANGE}...${NC}"
  done
  printf "\r\n${GREEN} ✔${NC} KEYCLOAK est dispo via ${ORANGE}http://localhost:${KEYCLOAK_PORT}${NC}\r\n"
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
  export SILL_KEYCLOAK_URL=http://localhost:${KEYCLOAK_PORT}
}

function remove_docker_image {
  read -p $'\e[33m$ ⬤ Entrez l\'Id ou le nom de l\'image à supprimer: \e[0m' image_id
  echo "Image supprimée: $image_id"
  docker rmi "$image_id"
}

function show_docker_containers {
  printf "${GREEN} ⬤ Liste des  containers Docker:${NC}\r\n"
  docker ps -a
}

function remove_docker_container {
  read -p $'\e[33m$ ⬤ Entrez l\'Id ou le nom du container à supprimer: \e[0m' container_id
  echo "Container supprimé: $container_id"
  docker rm "$container_id"
}

function stop_all_containers {
  printf "${GREEN} ⬤ Arrêt de tous les containers Docker:${NC}\r\n"
  docker stop $(docker ps -aq)
}

function reprint_options {
  echo "Options valides:"
  for index in "${!options[@]}"; do
    echo "$((index + 1))) ${options[index]}"
  done
}

function list_ports {
  echo "Liste des ports utilisés:"
  ss -ltn | grep LISTEN | grep 0.0.0.0:[0-9][0-9] | awk 'BEGIN{FS=" "} {print $4}' | awk 'BEGIN{FS=":"} {print $2}'
}

echo ""
PS3=$'\r\n\e[33m ---> Entrez votre choix:\e[0m\r\n'
select option in "${options[@]}"; do
  case $option in
  "Demarrer Keycloak")
    start_keycloak
    ;;
  "Arreter Keycloak")
    stop_keycloak
    ;;
  "Changer de port")
    change_port
    ;;
  "Afficher les images Docker")
    show_docker_images
    ;;
  "Supprimer une image Docker")
    remove_docker_image
    ;;
  "Afficher les containers Docker")
    show_docker_containers
    ;;
  "Supprimer un container Docker")
    remove_docker_container
    ;;
  "Arreter tous les containers Docker")
    stop_all_containers
    ;;
  "Liste des ports utilisés")
    list_ports
    ;;
  "Revoir les options")
    reprint_options
    ;;
  "Quitter")
    break
    ;;
  *)
    echo "Options invalide. Veuillez résessayer."
    ;;
  esac
done
