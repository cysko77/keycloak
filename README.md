# keycloak

# Source : https://osmosys.co/blog/backup-and-restore-of-docker-volumes-a-step-by-step-guide/

docker run --rm --mount source=docker_postgres_data,target=/post -v $(pwd):/backup busybox tar -czvf /backup/backup.tar.gz /post

docker run --rm --mount source=docker_postgres_data,target=/post -v $(pwd):/backup busybox tar -xzvf /backup/backup.tar.gz -C /
