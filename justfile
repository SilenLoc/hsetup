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
      --providers.docker=true \
      --providers.docker.allowEmptyServices=true

t:
    podman rm -f hello
    podman run -d \
            --name hello \
            --hostname hello.silenlocatelli.ch \
            -p 8000:8000 \
            -l traefik.enable="true" \
            -l traefik.http.routers.hello.rule=Host'(`hello.silenlocatelli.ch`)' \
            -l traefik.http.middlewares.hello-https-redirect.redirectscheme.scheme="https" \
            -l traefik.http.routers.hello.middlewares="hello-https-redirect" \
            -l traefik.http.routers.hello-secure.entrypoints="websecure" \
            -l traefik.http.routers.hello-secure.rule=Host'(`hello.silenlocatelli.ch`)' \
            -l traefik.http.routers.hello-secure.tls="true" \
            -l traefik.http.routers.hello-secure.tls.certresolver=lets-encrypt \
            docker.io/crccheck/hello-world

g:
    git add .
    git commit -m "Update"
    git push

pu:
    git pull