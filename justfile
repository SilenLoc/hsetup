import 'deploy.just'


up: down
    docker compose --env-file versions.env up -d 

down:
    docker compose down    

g:
    git add .
    git commit -m "Update"
    git push

pu:
    git pull