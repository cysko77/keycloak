FROM quay.io/keycloak/keycloak:25.0.2 as builder

# Configure a database vendor
ENV KC_DB=postgres
ARG THEME=dsfr-keycloak-theme-1.41.2.jar

WORKDIR /opt/keycloak

# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore

# Add theme keycloackfy
ADD --chown=keycloak:keycloak --chmod=644 ./${THEME} /opt/keycloak/providers/${THEME}

# Context: RUN the build command
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:25.0.2
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
