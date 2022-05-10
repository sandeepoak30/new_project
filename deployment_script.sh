#!/bin/bash
#Deployment script
#Author: Sandeep Oak

BRST_REPO_PATH="$WORKDIR/brst-diecut"
D10XIPR_REPO_PATH="$WORKDIR/d10xipr"
BRST_VENV_PATH="$WORKDIR/venv"


stop_gunicorn_n_nginx () {
    print_n_log "##########Stop Nginx Service############"
    sudo systemctl stop nginx.service

    print_n_log "##########Stop Gunicorn Service############"
    sudo systemctl stop unv_gunicorn.service
}

get_latest_code () {
    #PULL THE LATEST CHANGES

    cd $D10XIPR_REPO_PATH
    BRANCH=$(git branch)
    print_n_log " D10xipr repository branch version $BRANCH at $D10XIPR_REPO_PATH"
    git pull

    cd $BRST_REPO_PATH 
    BRANCH=$(git branch)
    print_n_log "brst-diecut repository branch version $BRANCH at $BRST_REPO_PATH"
    git pull
}

brst_activate_vertual_env () {
    source $BRST_VENV_PATH/bin/activate

    cd $BRST_REPO_PATH/src/python/brst_diecut
    python manage.py dxdeploy env=stage

start_gunicorn_n_nginx () {
    print_n_log "########## Start Gunicorn Service ############"
    sudo systemctl start bridgestone_gunicorn.service

    print_n_log "########## Start Nginx Service ############"
    sudo systemctl start nginx.service
}

