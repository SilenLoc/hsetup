import 'deploy.just'


up:
    docker compose --env-file versions.env up -d --always-recreate-deps

down:
    docker compose down    

g:
    git add .
    git commit -m "Update"
    git push

pu:
    git pull

    
restart_update:
    git pull
    just up
    
start_watch:
    watch --interval=3600 just restart_update
    