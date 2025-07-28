#!/usr/bin/fish
set -g fishConfigDir "$HOME/.config/fish"
set -g fishConfigFile "config.fish"

function install_urn-cli
  mkdir -p $fishConfigDir/urn-cli

  if test -e ./urn-cli.fish
    cp ./urn-cli-app.fish $fishConfigDir/urn-cli/
  else
    echo "urn-cli-app.fish not found"
    exit 1
  end
  if test -e ./urn-cli.fish
    cp ./urn-cli.fish $fishConfigDir/functions/
  else
    echo "urn-cli.fish not found"
    exit 1
  end

end

install_urn-cli
