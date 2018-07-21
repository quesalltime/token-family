#!/bin/bash

[ ! -f .env ] && cp .env.example .env
source .env

HERE=$(pwd)

# $1 is template/ifc_poa.json
# $2 is $POA_SIGNER_ADDRESS
function _modGenesis {
    sed -i "s%<POA_SIGNER_ADDRESS>%$2%g" $1

    # check if begins with 0x
    POA_SIGNER_ADDRESS_NO0x=$2

    [[ "$POA_SIGNER_ADDRESS_NO0x" == "0x"* ]] && \
    POA_SIGNER_ADDRESS_NO0x=$(echo $POA_SIGNER_ADDRESS_NO0x | sed "s%0x%%g")

    sed -i "s%<POA_SIGNER_ADDRESS_NO0x>%$POA_SIGNER_ADDRESS_NO0x%g" $1
}

# --------------------------------------------------------------------------------------------

[ ! -d "$GETH_HOST_DATA_VOL" ] && mkdir -p "$GETH_HOST_DATA_VOL"
[ ! -f "$GETH_HOST_DATA_VOL"/poa_signer.addr ] && touch "$GETH_HOST_DATA_VOL"/poa_signer.addr
echo $POA_SIGNER_ADDRESS > "$GETH_HOST_DATA_VOL"/poa_signer.addr

# replace genesis file
cd template
cp ifc_poa.json.tpl ifc_poa.json
_modGenesis ifc_poa.json $POA_SIGNER_ADDRESS
mv ifc_poa.json "$GETH_HOST_DATA_VOL"/ifc_poa.json
cd $HERE

# Run tmp geth container to geth init
docker run --name geth_tmp \
-v "$GETH_HOST_DATA_VOL":/gethdata \
$GETH_IMAGE:$GETH_IMAGE_TAG \
geth \
--datadir /gethdata \
init /gethdata/ifc_poa.json

# stop/rm container only after the status=exited
while :
do
    ids=$(docker ps -f "name=geth_tmp" -f "status=exited" -aq)
    if [ "$ids" != "" ]; then
        docker stop $(docker ps -f "name=geth_tmp" -aq) > /dev/null 2>&1
        docker rm $(docker ps -f "name=geth_tmp" -aq) > /dev/null 2>&1
        break
    fi
done