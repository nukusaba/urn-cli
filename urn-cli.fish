function urn-cli
  if test -e $HOME/.config/fish/urn-cli/urn-cli-app.fish
    $HOME/.config/fish/urn-cli/urn-cli-app.fish "$argv"
  else
    echo "urn-cli-app.fish is not installed"
    exit 1
  end
end
