#!/usr/bin/bash


read -p "Is nodejs installed on your system (y/n): " NODE_STATUS

if [ $NODE_STATUS = "y" ]
then
    set -o nounset # error when referencing undefined variable
    set -o errexit # exit when command fails

    # Install extensions
    #mkdir -p ~/.config/coc/extensions # TODO add a conditional to check existance
    cd ~/.config/coc/extensions
    if [ ! -f package.json ]
    then
        echo '{"dependencies":{}}'> package.json
    fi

    # add your extensions here
    npm install coc-snippets coc-python coc-tsserver coc-html coc-css coc-json coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
else
    echo "Install nodejs then run this script again"
fi
