# geth poa node #

## Requirement ##
### Install docker ###
Download the Docker.dmg and see the tutorial:   
https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac   

### Generate private key and store relative information ### 
Prepare .env  
```
cp .env.example .env
```

Generate private key(e.g. through myetherwallet) and fill it on the `POA_SIGNER_PRI_KEY` ,`POA_SIGNER_ADDRESS` and `POA_SIGNER_PWD` in .env


## How to use ##
1. geth init(poa genesis) according to `POA_SIGNER_ADDRESS` in .env
```
./1_geth_poa_init.sh
```

2. geth import private key according to `POA_SIGNER_PRI_KEY` and `POA_SIGNER_PWD` in .env
```
./2_import_private_key.sh
```

3. start geth
```
docker-compose up -d
```

## Note ##
1_geth_poa_init.sh adn 2_import_private_key.sh should be used at the same time,
because `POA_SIGNER_PRI_KEY` ,`POA_SIGNER_ADDRESS` and `POA_SIGNER_PWD` in .env are coordinated.