p user_id email_address:
    podman run -d \
      --name=traefik \
      --net podman \
      --security-opt label=type:container_runtime_t \
      -v /run/user/{{user_id}}/podman/podman.sock:/var/run/docker.sock:z \
      -v acme.json:/acme.json:z \
      -p 80:80 \
      -p 443:443 \
      -p 8080:8080 \
      docker.io/library/traefik:latest \
      --api.dashboard=true \
      --api.insecure=true \
      --certificatesresolvers.lets-encrypt.acme.email="{{email_address}}" \
      --certificatesresolvers.lets-encrypt.acme.storage=/acme.json \
      --certificatesresolvers.lets-encrypt.acme.tlschallenge=true \
      --entrypoints.http.address=":80" \
      --entrypoints.http.http.redirections.entryPoint.to=https \
      --entrypoints.http.http.redirections.entryPoint.scheme=https \
      --entrypoints.https.address=":443" \
      --providers.docker=true