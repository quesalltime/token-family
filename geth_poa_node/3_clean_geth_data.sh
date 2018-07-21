#!/bin/bash

[ ! -f .env ] && cp .env.example .env
source .env

[ -d "$GETH_HOST_DATA_VOL" ] && sudo rm -rf $GETH_HOST_DATA_VOL