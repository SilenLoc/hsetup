


@get-latest-release repo org="LunchTimeCode":
    gh release view --repo {{org}}/{{repo}} --json tagName --jq '.tagName' | sed 's/v//'

@update-version file repo org="LunchTimeCode":
    just replace-version {{repo}} $(just get-latest-release {{repo}} {{org}})

replace-version repo version:
    sed -i~ '/^{{repo}}_VERSION=/s/=.*/={{version}}/' versions.env
    rm -f versions.env~
       
@update:
    just update-version docker-compose.yml me
    just update-version docker-compose.yml jobs